
var data = [
  {"name": "AAAA",  "population": 70000,  "area": 29000 },
  {"name": "BBB",   "population": 600000, "area": 29000 },
  {"name": "CCC",   "population": 150000, "area": 350000},
  {"name": "DDDD",  "population": 25000,  "area": 24000 },
  {"name": "EEEEE", "population": 55000,  "area": 9000  },
  {"name": "FFFF",  "population": 70000,  "area": 29000 },
  {"name": "GGGG",  "population": 550000, "area": 29000 },
  {"name": "HHHH",  "population": 350000, "area": 350000},
  {"name": "IIII",  "population": 250000, "area": 24000 },
  {"name": "JJJJJ", "population": 44000,  "area": 9000  }
];


// the barchart
var responsiv_component = function (container, props){
  var { 
    width,
    height,
    margin
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
      .style("background-color", "#e3f4fc");

  var g = responsive_margin(svg, {margin_px, width, height });    
 
  var y_scale = d3.scaleBand()
    .domain(data.map (d=>{ return d.name})) 
    .range([0, inner_height]) 
    .paddingInner(0.3) 
    .paddingOuter(0.1) 
    .align(0.5); 
  
  labeled_y_axis_band(g, Object.assign({}, theme, {
      y_scale,
      inner_width,
      inner_height,
      margin_px
    }));  
  var x_scale = d3.scaleLinear()
    .domain([0, d3.max(data, d => {
      return (d.population);
    })])
    .range([0, inner_width]);
    
    labeled_x_axis_linear(g, Object.assign({}, theme, {
      x_scale,
      inner_width,
      inner_height
    }));

  var bars = g.selectAll("rect");
  bars = bars
  .data(data)
  .enter()
  .append("rect")  
    .merge(bars)
      .attr("fill", "rgb(126,190,199)")
      .attr("x", 0)//function(d){return x_scale(d.population)})
      .attr("y",  function(d){return y_scale(d.name)})
      .attr("width",d => { return x_scale(d.population)})// (d) => {return(d.area /2500)})
      .attr("height", y_scale.bandwidth);
};

var render_barchart = function () {
  responsiv_component(
    d3.select(".responsive_svg"),
    {
      width: document.querySelector(".responsive_svg").clientWidth,
      height: 0.5 * document.querySelector(".responsive_svg").clientWidth,
      margin: {"top": 0.2, "left": 0.13, "bottom":0.15, "right":0.3}
    });
};
 