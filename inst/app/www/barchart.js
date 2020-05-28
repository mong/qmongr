// the barchart
var responsiv_bar_chart = function (container, figure_data, props){
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
  
  
  container = d3.select("." + container.className);
  var inner_width = width - margin_px.left - margin_px.right;
  var inner_height= height - margin_px.top - margin_px.bottom;
  
  var svg = container.selectAll("svg").data([null]);
  svg = svg
    .enter()
    .append("svg")
    .merge(svg)
      .attr("width", width -20)
      .attr("height", height)
      .style("background-color", "#EEF6F7")
      .attr("class", "table_chart");

 
  var g = svg.selectAll(".grouped_element")
    .data([null]);
  g = g 
    .enter()
    .append("g")
    .attr("class", "grouped_element")
    .merge(g)
      .attr("transform", "translate(" + margin_px.left + " ," + margin_px.top  + ")");
  var y_scale = d3.scaleBand()
    .domain(figure_data.map (d => d.treatment_unit)) 
    .range([0, inner_height]) 
    .paddingInner(0.1) 
    .paddingOuter(0.0) 
    .align(0.5); 
  
  y_axis_band(g, Object.assign({}, theme_bar_chart, {
      y_scale,
      inner_width,
      inner_height,
      margin_px
    }));  
  var x_scale = d3.scaleLinear()
    .domain([0,1])
    .range([0, inner_width]);
    
   labeled_x_axis_linear(g, Object.assign({}, theme_bar_chart, {
      x_scale,
      inner_width,
      inner_height
    }));
    

  
  var bars = g.selectAll("rect");
  bars
    .data(figure_data)
    .enter()
    .append("rect")  
    .merge(bars)
      .attr("fill", d =>{
        var fill_color;
        if (Object.keys(d).some(elem => ["SykehusNavn", "Hfkortnavn", "RHF"].includes(elem))) {
          fill_color = "#7EBEC7";
        } else {
          fill_color ="#00263D";
        }
        return (fill_color);
      })
      .attr("x", 0)//function(d){return x_scale(d.andel)})
      .attr("y",  d=> y_scale(d.treatment_unit))
      .attr("width", d => x_scale(d.indicator))
      .attr("height", y_scale.bandwidth);
      
 
 
};