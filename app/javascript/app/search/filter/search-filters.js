// Handles search filter functionality.
import TextInput from 'app/search/filter/TextInput';
import geo from 'app/util/geolocation/geolocate-action';

// The search filters.
var _keyword;
var _agency;

// The form to submit.
var _searchForm;

var _categorySelect;

// Main module initialization.
function init() {

  // Set up geolocation button.
  geo.init('button-geolocate', _geolocationClicked);

  // Set up text input filters
  _keyword = TextInput.create('keyword-search-box');
  _agency = TextInput.create('org-name-options');

  // Capture form submission.
  _searchForm = document.getElementById('form-search');

  // Add on change funciton for category dropdown menu
  _categorySelect = document.getElementById('categories');
  _categorySelect.addEventListener('change', _updateSubCategories, false);

  // Hook reset button on the page and listen for a click event.
  var resetButton = document.getElementById('button-reset');
  resetButton.addEventListener('click', _resetClicked, false);

  var collapseButton = document.getElementById('button-collapse');
  collapseButton.addEventListener('click', _collapseSections, false);

  var hideFiltersButton = document.getElementById('button-hide-filters');
  hideFiltersButton.addEventListener('click', _hideFilters, false);

  var showFiltersButton = document.getElementById('button-show-filters');
  showFiltersButton.addEventListener('click', _showFilters, false);

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
  }

  _openCheckedSections();
}

function _updateSubCategories(){
  var selectedCategoryId = _categorySelect.value;
  var subCategoriesFilterTitleElement = document.getElementById('subcategoriesFilterTitle');
  var iconContainer = document.getElementById('iconContainer');
  var filterDropdownContainer = document.getElementById('filterDropdownContainer');
  var subcategoriesListContainerElement = document.getElementById('subcategoriesList');

  if (selectedCategoryId == ""){



  }else{

    $.ajax({
      type: 'POST',
      url: '/locations/get_subcategories_by_category',
      dataType: 'json',
      data: {
        category_id : selectedCategoryId,
      },
      success: function(data) {
        
        subCategoriesFilterTitleElement.textContent = data.category_title;
  
        iconContainer.classList.add("fa");
        iconContainer.classList.remove("fa-chevron-down");
        iconContainer.classList.add("fa-chevron-right");
  
        filterDropdownContainer.classList.add("filter-dropdown-closed");
  
        subcategoriesListContainerElement.innerHTML = "";
      
        data.sub_cat_array.forEach(element => {
          console.log("name: "+element[0]+"  id: "+element[1]);
  
          var li = document.createElement("li");
          li.classList.add("filter-category-item");
          li.classList.add("hide");
  
          var checkbox = document.createElement('input'); 
          checkbox.type = "checkbox";  
          checkbox.id = element[1];
  
          var subcategoryLabel = document.createElement('label');
          subcategoryLabel.appendChild(document.createTextNode(element[0]));
  
          li.appendChild(checkbox);
          li.appendChild(subcategoryLabel);
  
          subcategoriesListContainerElement.appendChild(li);
        });
        
      }
    });

  }


  
}

function _openCheckedSections() {
  var checkedBoxes = $('input:checkbox:checked');
  checkedBoxes.each(function() {
    if (!($(this).closest('ul').siblings('div').hasClass('selected'))) {
      _openSection($(this).closest('ul').siblings('div'));
    }
  });
}

function _openSection(element) {
  var filters = element.nextUntil('depth0');
  filters.each(function() {
    $(this).children(0).toggleClass('hide');
  });
  $(element).toggleClass('selected');
  $($(element).find('i')).toggleClass('fa fa-chevron-right fa fa-chevron-down');
}

function _collapseSections() {
  var sections = document.getElementsByClassName('parent-category-label-container');
  for (let section of sections) {
    _collapseSection($(section));
  }
}

function _collapseSection(element) {
  var filters = element.nextUntil('depth0');
  filters.each(function() {
    $(this).children(0).addClass('hide');
  });
  $(element).removeClass('selected');
  $($(element).find('i')).removeClass('fa-chevron-down').addClass('fa-chevron-right');
}

function _handleHeaderClick(evt) {
  _openSection($(evt.currentTarget));
}

function _linkClickedHandler(evt) {
  var el = evt.target;
  if (el.nodeName == 'INPUT') {
    _checkState('depth', 0, el);
  }
}

// The geolocation button was clicked in the location filter.
function _geolocationClicked(address) {
  document.getElementById('location').value = address;
  _searchForm.submit();
}

// The clear filters link was clicked.
function _resetClicked(evt) {
  _keyword.reset();
  _agency.reset();

  $('input:checkbox:checked').each(function() {
    $(this).removeAttr('checked');
  });

  evt.preventDefault();
  evt.target.blur();
}

function _hideFilters() {
  $('.filters-container').hide();
  $('#button-hide-filters').hide();
  $('#button-show-filters').css('display', 'block');
  $('#button-collapse').hide();
  $('#button-reset').hide();
}

function _showFilters() {
  $('.filters-container').show();
  $('#button-hide-filters').css('display', 'block');
  $('#button-show-filters').hide();
  $('#button-collapse').css('display', 'block');
  $('#button-reset').css('display', 'block');
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
