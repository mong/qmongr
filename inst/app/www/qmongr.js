//function that returns the tr based on a childElement of tr
//can be used to find  tr that was clicked.
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



//add a row benth the clicked tr
var add_row = function (clicked_tr) {
  var clicked_indicator = clicked_tr.id;
  var selected_treatment_units_element = document
    .getElementById("quality_overview_ui_1-pick_treatment_units")
    .getElementsByTagName("option");
  var selected_treatment_units = Array
    .from(selected_treatment_units_element)
    .map(elem => elem.value);
  var selected_year_element = document
    .getElementById("quality_overview_ui_1-pick_year")
    .getElementsByTagName("option");
  var selected_year = Array
    .from(selected_year_element)
    .map(elem => Number(elem.value));
  var figure_data = indicator_hosp
    .filter(elem => { 
      elem.treatment_unit = elem.SykehusNavn;
      return( elem.KvalIndID === clicked_indicator &&
        selected_treatment_units.includes(elem.SykehusNavn) &&
        elem.count > 5);
  });
  figure_data.push(indicator_hf
    .filter(elem => {
      elem.treatment_unit = elem.Hfkortnavn;
      return( elem.KvalIndID === clicked_indicator &&
        selected_treatment_units.includes(elem.Hfkortnavn) &&
        elem.count > 5);
    })
  );
  figure_data.push(indicator_rhf
    .filter(elem => {
      elem.treatment_unit = elem.RHF;
      return( elem.KvalIndID === clicked_indicator &&
      selected_treatment_units.includes(elem.RHF) &&
      elem.count > 5);
    })
  );
  figure_data.push(indicator_nat
    .filter(elem => {
      elem.treatment_unit = "Nasjonalt"; 
      return (elem.KvalIndID === clicked_indicator); 
    })
  );
  figure_data = figure_data.flat();
  
  var render_bar_chart = function () {
    responsiv_bar_chart(
      figure_container,
      figure_data.filter(elem => selected_year.includes(elem.Aar)),
      {
        width: svg_container.clientWidth,
        height: 0.5 * svg_container.clientWidth,
        margin: {"top": 0.1, "left": 0.25, "bottom":0.15, "right":0.15}
      });
  };
  
  var render_line_chart = function () {
    responsiv_line_chart(
      figure_container,
      figure_data ,
      {
        width: document.querySelector(".responsive_svg").clientWidth,
        height: 0.5 * document.querySelector(".responsive_svg").clientWidth,
        margin: {"top": 0.05, "left": 0.1, "bottom":0.15, "right":0.2}
      });
  };
    
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
   
  var figure_container = document.createElement('div');
  figure_container.setAttribute("class", "responsive_svg");
  added_td.appendChild(
    figure_container
  );

  var bar = document.getElementById("table_bar");
  var line = document.getElementById("table_line");
  var svg_container = document.querySelector(".responsive_svg");
  
  if (bar.checked ) {
    render_bar_chart();
    window.addEventListener('resize',render_bar_chart);
  } else if (line.checked){
     render_line_chart();
    window.addEventListener('resize', render_line_chart);
    
  }
  
  bar.addEventListener("click",e => {
    if (document.getElementById("table_bar").checked ) {
       var figure_elemnts = svg_container.childElementCount
       for (i = 0; i < figure_elemnts; i++){ 
        svg_container.removeChild(svg_container.childNodes[0]);
      }
      window.removeEventListener('resize', render_line_chart);
      render_bar_chart();
      window.addEventListener('resize', render_bar_chart);
    } 
  });
  
  line.addEventListener("click",e => {
    if (document.getElementById("table_line").checked ) {
      var figure_elemnts = svg_container.childElementCount
       for (i = 0; i < figure_elemnts; i++){ 
        svg_container.removeChild(svg_container.childNodes[0]);
      }
      window.removeEventListener('resize',render_bar_chart);
      render_line_chart();
      window.addEventListener('resize', render_line_chart);
    } 
  });
 
};

var qi_table = document.querySelector("#quality_overview_ui_1-qi_table");
var current_fig_row = "";
var button_object = [
  {class_name_inp : "figure_button figure_button_left", type : "Radio", id: "table_bar",  name: "table_figure_button",
    value: "bar",  icon: "fa fa-bar-chart", label : "Søyle", class_name_label: "figure_button_label", checked: true },
  {class_name_inp : "figure_button figure_button_right", type : "Radio", id: "table_line", name: "table_figure_button",
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