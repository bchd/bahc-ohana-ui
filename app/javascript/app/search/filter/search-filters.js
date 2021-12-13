// Handles search filter functionality.
import TextInput from 'app/search/filter/TextInput';
import map from 'app/result/result-map';

// The search filters.
var _keyword;
var _agency;

// The form to submit.
var _searchForm;

var _categorySelect;

// Main module initialization.
function init() {

  // Set up text input filters
  _keyword = TextInput.create('keyword-search-box');
  _agency = TextInput.create('org-name-options');

  // Capture form submission.
  _searchForm = document.getElementById('form-search');

  // Add on change function for category dropdown menu
  _categorySelect = document.getElementById('main_category');
  _categorySelect.addEventListener('change', _updateSubCategories, false);

  var checkboxes = $('#categories input');

  var currentCheckbox;
  for (var i=0; i < checkboxes.length; i++) {
    currentCheckbox = checkboxes[i];
    _checkState('depth',0,currentCheckbox);
  }

  var curr;
  for (var l = 0; l < checkboxes.length; l += 1) {
    curr = checkboxes[l];
    $(curr).click(_linkClickedHandler);
  }

  var parentFilterHeaders = document.getElementsByClassName('parent-category-label-container');
  for (var l = 0; l < parentFilterHeaders.length; l += 1) {
    curr = parentFilterHeaders[l];
    curr.addEventListener('click', _handleHeaderClick, false);
    curr.addEventListener('keydown', _handleHeaderClick, false);
  }

  _openCheckedSections();
  
  $("#reset-button").click(e => _resetFilters(e));
  $("#button-geolocate").click(e => _getCurrentLocation(e));
  $("#form-search").change(e => _handleFormChange(e));
  $("#keyword").on('input', debounce(() => {_getSearchResults()}, 500));
  $("#address").on('input', debounce(() => {_getSearchResults()}, 500));

}

var debounce = function (func, wait, immediate) {
  var timeout;
  return function() {
      var context = this, args = arguments;
      var later = function() {
              timeout = null;
              if (!immediate) func.apply(context, args);
      };
      var callNow = immediate && !timeout;
      clearTimeout(timeout);
      timeout = setTimeout(later, wait);
      if (callNow) func.apply(context, args);
  };
};

function _handleFormChange(e){

  if (e.target.type == "text" || e.target.type == "search"){ return; } 

  if (e.target.id == "main_category"){
    //if main category was changed clear subcategories before form submit
    $( "input[name='categories[]']" ).prop('checked', false);
  };

  if ($("#address").val() != "Current Location"){
    $('#button-geolocate').removeClass('geolocated');
  }

  _getSearchResults(e);

}

function _getCurrentLocation(e){
  
  var options = {
    enableHighAccuracy: false,
    timeout: 20000,
    maximumAge: 9999999
  };

  function success(pos) {
    let crd = pos.coords;
    $('#lat').val(crd.latitude);
    $('#long').val(crd.longitude);
    $("#bar").hide();
    _getSearchResults(e)
  };

  function error(err) {
    console.warn(`ERROR(${err.code}): ${err.message}`);
  }

  var i = 0;
  function moveLoadingBar() {
    if (i == 0) {
      i = 1;
      var elem = document.getElementById("bar");
      var width = 1;
      var id = setInterval(frame, 30);
      function frame() {
        if (width >= 100) {
          clearInterval(id);
          i = 0;
        } else {
          width++;
          elem.style.width = width + "%";
        }
      }
    }
  }

  
  e.preventDefault();
  $('#address').val('Current Location');
  $('#button-geolocate').addClass('geolocated');
  $('#bar').show();
  moveLoadingBar();
  navigator.geolocation.getCurrentPosition(success, error, options);

}

function _resetFilters(e){
  e.preventDefault();
  $(':input').each(function() {
    $(this).val("");
  });
  _updateSubCategories();
  _getSearchResults(e);
}

function _getSearchResults(e){

  var formData = $("#form-search").serialize();
  const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content');

    $.ajax({
      type: 'GET',
      url: '/locations',
      headers: {
        'X-CSRF-Token': csrfToken,
        'accept':"text/html"
      },
      data: formData + "&layout=false&form=true",
      success: function(response) {
        $("#results-container").empty();
        $("#results-container").append(response);

        if ( $("#map-view").length ){
          map.init();
        }

        //remove layout=false from pagination hrefs
        $('a').each(function(){ 
            var oldUrl = $(this).attr("href");
            var newUrl = oldUrl.replace("&layout=false", ""); 
            $(this).attr("href", newUrl); 
        });
        
      }
    });  
}




function _updateSubCategories(){
  var selectedCategoryName = _categorySelect.value;
  var subCategoriesFilterTitleElement = document.getElementById('subcategoriesFilterTitle');
  var iconContainer = document.getElementById('iconContainer');
  var filterDropdownContainer = document.getElementById('filterDropdownContainer');
  var subcategoriesListContainerElement = document.getElementById('subcategoriesList');
  var categoriesFiltersContainer = document.getElementById('categoryFiltersContainerDiv');
  var subcategoriesFilterTitle = document.getElementById('subcategoriesFilterTitle');
  var parentCategoryDiv = document.getElementById('parent-category');

  if (selectedCategoryName == ""){

    subCategoriesFilterTitleElement.textContent = "Select a Topic from above to display additional filters.";
    subcategoriesFilterTitle.classList.remove("parent-category-label");
    subcategoriesFilterTitle.classList.add("filter-description-label");
    subcategoriesListContainerElement.innerHTML = "";
    iconContainer.classList.remove("fa");
    iconContainer.classList.remove("fa-chevron-down");
    iconContainer.classList.remove("fa-chevron-right");
    parentCategoryDiv.classList.remove("hoverable");
    parentCategoryDiv.setAttribute("aria-label", "Select a Topic from above to display additional filters.");
    parentCategoryDiv.setAttribute("aria-expanded", "false");

  }else{

    const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content');

    $.ajax({
      type: 'POST',
      url: '/locations/get_subcategories_by_category',
      dataType: 'json',
      headers: {
        'X-CSRF-Token': csrfToken,
      },
      data: {
        category_name : selectedCategoryName,
      },
      success: function(data) {
        
        subCategoriesFilterTitleElement.textContent = data.category_title;
  
        iconContainer.classList.add("fa");
        iconContainer.classList.remove("fa-chevron-down");
        iconContainer.classList.add("fa-chevron-down");

        subcategoriesFilterTitle.classList.add("parent-category-label");
        subcategoriesFilterTitle.classList.remove("filter-description-label");

        parentCategoryDiv.classList.add("hoverable");
        parentCategoryDiv.setAttribute("aria-label", "Click enter to expand and collapse filters");
        parentCategoryDiv.setAttribute("aria-expanded", "false");
  
        filterDropdownContainer.classList.add("filter-dropdown-closed");
  
        subcategoriesListContainerElement.innerHTML = "";
      
        data.sub_cat_array.forEach(subCategoryName => {

          var id_string = "category_"+subCategoryName.replace(/ /g,'')
  
          var container = document.createElement("div");
          container.classList.add("filter-category-item");
          // container.classList.add("hide");
  
          var checkbox = document.createElement('input'); 
          checkbox.type = "checkbox";  
          checkbox.id = id_string;
          checkbox.name = "categories[]";
          checkbox.value = subCategoryName;
  
          var subcategoryLabel = document.createElement('label');
          subcategoryLabel.appendChild(document.createTextNode(subCategoryName));
          subcategoryLabel.setAttribute("for", id_string)
  
          container.appendChild(checkbox);
          container.appendChild(subcategoryLabel);
  
          subcategoriesListContainerElement.appendChild(container);
        });
      }
    });
  }
}

function _openCheckedSections() {
  var checkedBoxes = $('input:checkbox:checked');
  checkedBoxes.each(function() {
    if (($(this).closest('fieldset').siblings('div').hasClass('selected'))) {
      _openSection($(this).closest('fieldset').siblings('div'));
    }
  });
}

function _openSection(element) {
  
  document.querySelectorAll('.filter-category-item').forEach(function(item) {
    $(item).toggleClass('hide');
  });

  $(element).attr('aria-expanded', function (i, attr) {
    return attr == 'true' ? 'false' : 'true'
  });

  $(element).toggleClass('selected');
  $($(element).find('i')).toggleClass('fa fa-chevron-right fa fa-chevron-down');
}

function _collapseSections(evt) {
  if (evt.key === "Enter" || evt.type === 'click') {
    var sections = document.getElementsByClassName('parent-category-label-container');
    for (let section of sections) {
      _collapseSection($(section));
    }
  }
}

function _collapseSection(element) {
  var filters = element.nextUntil('depth0');
  filters.each(function() {
    $(this).children(0).addClass('hide');
  });
  $(element).attr('aria-expanded', 'false');
  $(element).removeClass('selected');
  $($(element).find('i')).removeClass('fa-chevron-down').addClass('fa-chevron-right');
}

function _handleHeaderClick(evt) {
  if (evt.key === "Enter" || evt.type === 'click') {
    _openSection($(evt.currentTarget));
  }
}

function _linkClickedHandler(evt) {
  var el = evt.target;
  if (el.nodeName == 'INPUT') {
    _checkState('depth', 0, el);
  }
}

function _checkState(prefix,depth,checkbox) {
  var item = $(checkbox).parent(); // parent li item
  var id = prefix+String(depth);
  while(!item.hasClass(id)) {
    depth++;
    id = prefix + String(depth);
  }

  id = 'li.' + prefix + String(depth+1);
  var lnks = $(id, item);
  var curr;
  for (var l=0; l < lnks.length; l++) {
    curr = lnks[l];
    if (checkbox.checked) {
      $(curr).removeClass('hide');
    }
    else {
      $(curr).addClass('hide');
      checkbox = $('input',$(curr));
      checkbox.prop('checked', false);
      _checkState(prefix,depth,checkbox);
    }
  }

}

export default {
  init:init
};
