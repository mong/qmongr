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