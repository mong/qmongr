// line chart
var responsiv_line_chart = function (container,figure_data, props){
  var { 
    width,
    height,
    margin,
  } = props;
  var margin_px = {
    top: height * margin.top,
    bottom: height * margin.bottom,
    right: width * margin.right,
    left: width * margin.left,
  };
  var inner_width = width - margin_px.left - margin_px.right;
  var inner_height= height - margin_px.top - margin_px.bottom;

  container = d3.select("." + container.className);
    
  var x_scale = d3.scaleTime()
    .domain([
      d3.min(figure_data, d =>{ return new Date (d.Aar+ "")}),
      d3.max(figure_data, d =>{ return new Date (d.Aar+"")})]) 
    .range([0, inner_width]);
  
  var y_scale = d3.scaleLinear()
    .domain([0,1])
    .range([inner_height , 0]); 

  var nested = d3.nest()
    .key(d=>{return (d.treatment_unit)})
    .entries(figure_data);

  var line_color_scale = d3.scaleOrdinal()
    .domain(nested.map(d => {return (d.key)}))
    .range(colors.chart_colors);
  
  color_legend_line_chart(container, Object.assign({}, theme_line_chart, {
    line_color_scale,
    inner_width,
    inner_height,
    margin,
    position_left :margin_px.left, 
  })); 
    
  
  
  var svg = container.selectAll("svg").data([null]);
  svg = svg
  .enter()
  .append("svg")
  .merge(svg)
  .attr("width", width -20)
  .attr("height", height)
  .style("background-color", colors.background_color);
    
  var g = svg.selectAll(".grouped_element" )
    .data([null]);
  g = g 
    .enter()
    .append("g")
    .attr("class", "grouped_element")
    .merge(g)
      .attr("transform", "translate(" + margin_px.left + " ," + margin_px.top  + ")");
  
  
 
  labeled_y_axis_linear(g, Object.assign({}, theme_line_chart, {
    y_scale,
    inner_width,
    inner_height,
  }));  


  

  var x_axis_tick_values =[...new Set(figure_data.map(d =>{ return  (d.Aar+ "")}))];
  x_axis_tick_values = x_axis_tick_values.map(d => {return new Date(d)});

  labeled_x_axis_time(g, Object.assign({}, theme_line_chart, {
    x_scale,
    inner_width,
    inner_height,
    x_axis_tick_values
  }));

  
  var lines = d3.line()
    .x(d => {return x_scale(new Date(d.Aar +""))})
    .y(d => {return y_scale(d.indicator)});
    //.curve(d3.curveMonotoneX)

  var path =  g.selectAll(".table-line-chart");
  path = path  
    .data(nested)
    .enter()
    .append("path")
    .merge(path)
      .attr("class",d =>`table-line-chart  ${d.key.replace(/\s/g, '')}`)
      .attr("d", d => {return lines(d.values)})
      .attr("stroke", (d) => { 
        return line_color_scale(d.key)})
      .style("stroke-width", 3)
      .style("stroke-linejoin", "round")
      .style("stroke-linecap", "round")
      .attr("fill","none")
      .style("mix-blend-mode", "multiply");


  color_legend_line_chart(container, Object.assign({}, theme_line_chart, {
    line_color_scale,
    inner_width,
    inner_height,
    margin,
    position_left :margin_px.left, 
  }));
};
