//data place holder
var data_line = [
  {"name": "Helse Midt-Norge RHF",  "andel": 0.3,  "pop": 29000 , "year":2014},
  {"name": "Helse Midt-Norge RHF",  "andel": 0.33,  "pop": 54000, "year":2015 },
  {"name": "Helse Midt-Norge RHF",  "andel": 0.37,  "pop": 93000, "year":2016 },
  {"name": "Helse Midt-Norge RHF",  "andel": 0.43,  "pop": 56000, "year":2017 },
  {"name": "Helse Midt-Norge RHF",  "andel": 0.4,  "pop": 62000, "year":2018 },
  {"name": "Helse Midt-Norge RHF",  "andel": 0.29,  "pop": 36000, "year":2019 },
  {"name": "Bergen HF",   "andel": 0.36, "pop": 21000, "year":2014 },
  {"name": "Bergen HF",   "andel": 0.386, "pop": 67000, "year":2015 },
  {"name": "Bergen HF",   "andel": 0.21, "pop": 95000, "year":2016 },
  {"name": "Bergen HF",   "andel": 0.355, "pop": 33000, "year":2017 },
  {"name": "Bergen HF",   "andel": 0.432, "pop": 56000, "year":2018 },
  {"name": "Bergen HF",   "andel": 0.314, "pop": 48000, "year":2019 },
  {"name": "Tromsø",   "andel": 0.44, "pop": 310000, "year": 2014},
  {"name": "Tromsø",   "andel": 0.34, "pop": 120000, "year": 2015},
  {"name": "Tromsø",   "andel": 0.26, "pop": 220000, "year": 2016},
  {"name": "Tromsø",   "andel": 0.3167, "pop": 680000, "year": 2017},
  {"name": "Tromsø",   "andel": 0.395, "pop": 120000, "year": 2018},
  {"name": "Tromsø",   "andel": 0.32, "pop": 530000, "year": 2019},
  {"name": "Helse Nord RHF",   "andel": 0.357, "pop": 310000, "year": 2014},
  {"name": "Helse Nord RHF",   "andel": 0.34, "pop": 120000, "year": 2015},
  {"name": "Helse Nord RHF",   "andel": 0.23, "pop": 220000, "year": 2016},
  {"name": "Helse Nord RHF",   "andel": 0.39, "pop": 680000, "year": 2017},
  {"name": "Helse Nord RHF",   "andel": 0.384, "pop": 120000, "year": 2018},
  {"name": "Helse Nord RHF",   "andel": 0.375, "pop": 530000, "year": 2019}
];

// line chart
var responsiv_line_chart = function (container, props){
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
  .style("background-color", colors.background_color);
  
  /*responsive_margin(svg, {margin_px, width, height }) */   
    
  var g = svg.selectAll(".grouped_element" )
    .data([null]);
  g = g 
    .enter()
    .append("g")
    .attr("class", "grouped_element")
    .merge(g)
      .attr("transform", "translate(" + margin_px.left + " ," + margin_px.top  + ")");
  
  
  var y_scale = d3.scaleLinear()
    .domain([0,1])
    //d3.min(data_line, d =>{ return d.andel}),
    //d3.max(data_line, d =>{ return d.andel})]) 
    .range([inner_height , 0]); 
  labeled_y_axis_linear(g, Object.assign({}, theme_line_chart, {
    y_scale,
    inner_width,
    inner_height,
  }));  


  var x_scale = d3.scaleTime()
    .domain([
      d3.min(data_line, d =>{ return new Date (d.year+ "")}),
      d3.max(data_line, d =>{ return new Date (d.year+"")})]) 
    .range([0, inner_width]);

  var x_axis_tick_values =[...new Set(data_line.map(d =>{ return  (d.year+ "")}))];
  x_axis_tick_values = x_axis_tick_values.map(d => {return new Date(d)});

  labeled_x_axis_time(g, Object.assign({}, theme_line_chart, {
    x_scale,
    inner_width,
    inner_height,
    x_axis_tick_values
  }));

  var nested = d3.nest()
    .key(d=>{return (d.name)})
    .entries(data_line);

  var line_color_scale = d3.scaleOrdinal()
    .domain(nested.map(d => {return (d.key)}))
    .range(colors.chart_colors);

  var lines = d3.line()
    .x(d => {return x_scale(new Date(d.year +""))})
    .y(d => {return y_scale(d.andel)});
    //.curve(d3.curveMonotoneX)

  var path =  g.selectAll(".table-line-chart");
  path = path  
    .data(nested)
    .enter()
    .append("path")
    .merge(path)
      .attr("class","table-line-chart")
      .attr("d", d => {return lines(d.values)})
      .attr("stroke", (d) => { 
        return line_color_scale(d.key)})
      .style("stroke-width", 3)
      .style("stroke-linejoin", "round")
      .style("stroke-linecap", "round")
      .attr("fill","none")
      .style("mix-blend-mode", "multiply");


  color_legend_line_chart(svg, Object.assign({}, theme_line_chart, {
    line_color_scale,
    inner_width,
    inner_height,
    position_left :margin_px.left, 
  }));
};

var render_line_chart = function () {
  responsiv_line_chart(
    d3.select(".responsive_svg"),
    {
      width: document.querySelector(".responsive_svg").clientWidth,
      height: 0.5 * document.querySelector(".responsive_svg").clientWidth,
      margin: {"top": 0.2, "left": 0.1, "bottom":0.15, "right":0.2}
    });
};

//render_line_chart();
//addEventListener('resize', render_line_chart);



