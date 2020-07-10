// set time out due to delayed loading of shiny elements
// top property of position is variable because the width of the top navbar changes
setTimeout(function() {
document.getElementById("quality_overview_ui_1-pick_treatment_units").onchange = function (e){
  var top_nav_bar = document.querySelector(".treatment_unit");
  var bottom_tu = top_nav_bar.clientHeight;
  var top_tu = bottom_tu - 20;
  top_nav_bar.setAttribute("style", "top:" + -top_tu + "px;");

};

document.querySelector(".treatment_unit").onmouseenter = function (e){
 var top_nav_bar = document.querySelector(".treatment_unit");
 top_nav_bar.setAttribute("style", "top:-10px;");
};
document.querySelector(".treatment_unit").onmouseleave = function (e){
  var top_nav_bar = document.querySelector(".treatment_unit");
  var bottom_tu = top_nav_bar.clientHeight;
  var top_tu = bottom_tu - 20;
  top_nav_bar.setAttribute("style", "top:" + -top_tu + "px;");
};
}, 3000);