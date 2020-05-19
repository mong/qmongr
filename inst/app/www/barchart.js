var data_bar = [
  {"name": "Helse midt-norge RHF",  "andel": 0.3},
  {"name": "Bergen HF",   "andel": 0.6},
  {"name": "Tromsø",   "andel": 0.44},
  /*{"name": "Helse Nord RHF",  "andel": .25000 },
  {"name": "Helse Sør-Øst RHF", "andel": .55000 },
  {"name": "OUS HF",  "andel": .80000 },*/
  {"name": "Volvat Majorstuen",  "andel": 0.350},
  {"name": "Rikshospitalet",  "andel": 0.250},
  {"name": "Radiumhospitalet", "andel": 0.44}
];


// the barchart
// the barchart
var responsiv_bar_chart = function (container, props){
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
  
  var svg = container.selectAll("svg").data([null]);
  svg = svg
    .enter()
    .append("svg")
    .merge(svg)
      .attr("width", width -20)
      .attr("height", height)
      .style("background-color", "#EEF6F7")
      .attr("class", "table_chart");

  //var g = responsive_margin(svg, {margin_px, width, height })    
  var g = svg.selectAll(".grouped_element")
    .data([null]);
  g = g 
    .enter()
    .append("g")
    .attr("class", "grouped_element")
    .merge(g)
      .attr("transform", "translate(" + margin_px.left + " ," + margin_px.top  + ")");
  var y_scale = d3.scaleBand()
    .domain(data_bar.map (d=>{ return d.name})) 
    .range([0, inner_height]) 
    .paddingInner(0.1) 
    .paddingOuter(0.1) 
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

  var tooltip = g.selectAll(".table-bar-chart-tooltip").data([null]);
  tooltip = tooltip.enter()
    .append("div")
    .merge(tooltip)
      .attr("class", "table-bar-chart-tooltip")
      .style("opacity", 0)
      .style("position", "absolute")
      .style("background-color", "#eaf7fc")
      .style("font-family", "areal")
      .style("border", "2px solid white")
      .style("border-radius", "5px")
      .style("padding", "5px")
      .style("display","inline-block");
  var mouseover = function(d) {
      tooltip
        .style("opacity", 1)
        .html(d.name +":<br> " + d.andel)
        .style("left", d3.event.pageX + "px")
        .style("top", d3.event.pageY    + "px");

    };
  var mousemove = function(d) {
       
      tooltip
        .html(d.name +":<br> " + d.andel)
        .style("left", d3.event.pageX    + "px")
        .style("top", d3.event.pageY   + "px");
        
    };
  var mouseleave = function(d) {
      tooltip
        .style("opacity", 0);
    };

  var bars = g.selectAll("rect");
  bars
    .data(data_bar)
    .enter()
    .append("rect")  
    .merge(bars)
      .attr("fill", "#7EBEC7")
      .attr("x", 0)//function(d){return x_scale(d.andel)})
      .attr("y",  function(d){return y_scale(d.name)})
      .attr("width",d => { return x_scale(d.andel)})// (d) => {return(d.area /2500)})
      .attr("height", y_scale.bandwidth)
      .on( "mouseover", mouseover)
      .on("mousemove", mousemove)
      .on("mouseleave", mouseleave);
 
};


//renders the figure
var render_bar_chart = function () {
  responsiv_bar_chart(
    d3.select(".responsive_svg"),
    {
      width: document.querySelector(".responsive_svg").clientWidth,
      height: 0.5 * document.querySelector(".responsive_svg").clientWidth,
      margin: {"top": 0.1, "left": 0.25, "bottom":0.15, "right":0.15}
    });
};
 