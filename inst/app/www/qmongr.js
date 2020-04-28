//function that returns the tr based on a childElement of tr
//can be used to find the tr that was clicked.
var tr_class_name = function (clicked_element) {
  if (clicked_element.nodeName === "TR") {
    	return clicked_element;
  } else if (clicked_element.parentElement.nodeName !== "BODY" ) {
  	return tr_class_name(clicked_element.parentElement);
  } else {
    return "BODY";
  }
};

//the Radio buttons that control the type of figure that will be shown in the table
var add_figure_buttons = function (container_class, button_object) {
  var button_container = document.createElement('div');
      button_container.className = container_class;
  button_object.forEach( function(array_input) {
    var input = document.createElement('input');
    input.type = array_input.type;
    input.value = array_input.value ;
    input.id = array_input.id ;
    input.name = array_input.name ;
    input.className = array_input.class_name_inp;
    input.checked = array_input.checked;
    
    var label = document.createElement("label");
    label.setAttribute("for",array_input.id);
    label.textContent = array_input.label;
    label.className = array_input.class_name_label;
    var icon = document.createElement("i");
    icon.className = array_input.icon; 
    label.appendChild(icon);
    button_container.appendChild(input);    
    button_container.appendChild(label);
  });
  return (button_container);
};

//removes the figure rows when a new tr is checked
var remove_row = function() {
  var rm_element = document.querySelector(".tr_figure");
  if (rm_element !== null){
    rm_element.parentNode.removeChild(rm_element);
  }
} ;

//adds a bar or line chart based on user input
/*var add_figure = function () {
  var figure_container = document.createElement('div');
  figure_container.className = "embedded_figure";
  
  
  var svg = d3.select(figure_container).append("svg")
    .attr("width", 400)
    .attr("height", 500);
  var text = svg.append("text")
    .attr("x", 200)
    .attr("y", 250)
    .attr("font-size", "1.3em")
    .attr("text-anchor","middle")
    .attr("fill","blue")
    .text("Figure coming soon ...")
  return(figure_container);
};
*/
var barchart = function( container_div) {
  
};

var linechart = function (container_div) {
  
};

//add a row benth the clicked tr
var add_row = function (clicked_tr) {
  
  new_row_index = clicked_tr.rowIndex + 1;
  current_fig_row = clicked_tr.id;
  added_row = clicked_tr.parentElement
    .parentElement
    .insertRow(new_row_index);
  added_row.className = "tr_figure";  
  added_td = added_row.appendChild(
    document.createElement("td")
  );
  added_td.setAttribute("colspan", clicked_tr.childElementCount);
  added_td.appendChild(
    add_figure_buttons("tr_figure_button", button_object)
  );
  var fig_cont = document.createElement('div');
  fig_cont.setAttribute("class", "responsive_svg");
  added_td.appendChild(
    fig_cont
  );
  render_barchart();
  addEventListener('resize', render_barchart);
};

var qi_table = document.querySelector("#quality_overview_ui_1-qi_table");
var current_fig_row = "";
var button_object = [
  {class_name_inp : "figure_button figure_button_left", type : "Radio", id: "bar",  name: "figure_button",
    value: "bar",  icon: "fa fa-bar-chart", label : "Søyle", class_name_label: "figure_button_label", checked: true },
  {class_name_inp : "figure_button figure_button_right", type : "Radio", id: "line", name: "figure_button",
    value: "line", icon: "fa fa-line-chart", label : "Linje", class_name_label: "figure_button_label", checked: false}
  ];


qi_table.addEventListener("click", function(e){
  var clicked_tr = tr_class_name(e.target);
  var new_row_index;
  var added_row;
  var added_td;
  if (clicked_tr.className === "indicator" ) {
    
    if(current_fig_row === "")  {
      add_row(clicked_tr);
    } else if (current_fig_row === clicked_tr.id) {
      remove_row();
      current_fig_row = "";
    }else {
      remove_row();
      add_row(clicked_tr);
    }
  }
}) ; 


