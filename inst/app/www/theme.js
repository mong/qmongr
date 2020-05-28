//colors
var colors =   {
  "chart_colors": 
    [  "#4F9A94", "#90CAF9", "#B0BEC5",  "#FFE082", "#2962FF", "#CE93D8", "#9C786C",
    "#BCAAA4", "#F8BBD0","#9FA8DA", "#80DEEA", "#A5D6A7","#E6EE9C", "#FFAB91", "#78909C"],
  "line_color" : "#D2D3D4",
  "background_color": "#EEF6F7",
  "primary_text_color" : "#2D3034",
  "secondary_text_color" : "#828586",
  "primary_color" : "#7EBEC7",
  "secondary_color" : "#00263D",
  "traffic_light_colors": {high:"#BFE389", mid : "#F%A623", low : "#F04157"}
};


//defines how the line chart axis look 
var theme_line_chart = {
  x_axis_label_fill: colors.primary_text_color,
  y_axis_label_fill: colors.primary_text_color,
  x_axis_label: "",
  y_axis_label: "Andel",
  x_axis_label_font_family: 'areal, Helvetica Neue',
  y_axis_label_font_family: 'areal, Helvetica Neue',
  x_axis_tick_font_fill: colors.secondary_text_color,
  y_axis_tick_font_fill: colors.secondary_text_color,
  y_axis_tick_number: 6,
  x_axis_tick_line_stroke: "none",
  y_axis_tick_line_stroke: colors.line_color,
  x_axis_domain_line_stroke: "none",
  y_axis_domain_line_stroke: 'none',
  legend_text_fill:colors.primary_text_color,
  legend_text_font_family: 'areal, Helvetica Neue',
};

//defines how the bar chart axis look
var theme_bar_chart = {
  x_axis_label_fill: colors.secondary_text_color,
  y_axis_label_fill: colors.secondary_text_color,
  x_axis_label: "",
  y_axis_label: "",
  x_axis_label_font_family: 'areal',
  y_axis_label_font_family: 'areal',
  x_axis_tick_font_fill: colors.secondary_text_color,
  y_axis_tick_font_fill: colors.primary_text_color,
  x_axis_tick_line_stroke: colors.line_color,
  y_axis_tick_line_stroke: 'none',
  x_axis_domain_line_stroke: 'none',
  y_axis_domain_line_stroke: 'none',
};