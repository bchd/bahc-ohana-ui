// Handles search filter functionality.
import TextInput from 'app/search/filter/TextInput';
import geo from 'app/util/geolocation/geolocate-action';

// The search filters.
var _keyword;
var _location;
var _agency;

// The form to submit.
var _searchForm;

// Main module initialization.
function init() {

  // Set up geolocation button.
  geo.init('button-geolocate', _geolocationClicked);

  // Set up text input filters
  _keyword = TextInput.create('keyword-search-box');
  _location = TextInput.create('location-options');
  _agency = TextInput.create('org-name-options');

  // Capture form submission.
  _searchForm = document.getElementById('form-search');

  // Hook reset button on the page and listen for a click event.
  var resetButton = document.getElementById('button-reset');
  resetButton.addEventListener('click', _resetClicked, false);

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

// The clear filters button was clicked.
function _resetClicked(evt) {
  _keyword.reset();
  _location.reset();
  _agency.reset();

  evt.preventDefault();
  evt.target.blur();
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
      console.log('checked!!');
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
