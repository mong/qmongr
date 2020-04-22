var add_figure = function () {
  
  var figure_container = document.createElement('div');
  figure_container.className = "svg_container";
  
  var data = [
  {"name": "AAAA",
   "population": 700},
  {"name": "BBB",
   "population": 540},
  {"name": "CCC",
   "population": 450},
  {"name": "DDDD",
   "population": 250},
  {"name": "EEEEE",
   "population": 500},
  ];
  
  
  
  var margin = {"top": 50, "left": 50, "bottom":50, "right":50};
  var svg_height = 500; 
  var svg_width = 500; 
  var height = svg_height -margin.top -margin.bottom;
  var width = svg_width - margin.right -margin.left;
  
  var y_scale = d3.scaleBand()
   .domain(data.map(d=>{ return d.name})) 
    .range([0, height]) 
    .paddingInner(0.1) 
    .paddingOuter(0.1) 
    .align(0.5); 
  
  var x_scale = d3.scaleLinear()
    .domain([0, d3.max(data,d => {
      return (d.population);
    })])
    .range([0, width]);

  var svg = d3.select(figure_container).append("svg")
    .attr("width", svg_width ) 
    .attr("height", svg_height );
    
  var g = svg.append("g")
    .attr("transform", "translate(" + margin.left + " ," + margin.top + ")");

  var bars = g.selectAll("rect")
    .data(data).enter()
    .append("rect")
    .attr("x", 0)//function(d){return x_scale(d.population)})
    .attr("y",  function(d){return y_scale(d.name)})
    .attr("width",d => { return x_scale(d.population)})// (d) => {return(d.area /2500)})
    .attr("height", y_scale.bandwidth)
    .attr("fill", "rgb(126,190,199)");

  var y_axis = d3.axisRight(y_scale);
  var y_axis_g =  g.append("g")
    .attr("class", "y axis")
    .call(y_axis);
  y_axis_g
    .selectAll("text")
    .attr("text-anchor", "end")
    .attr("transform", "translate(-20,0)");
  y_axis_g
    .selectAll('.tick')
    .attr('fill', "#635F5D");
   y_axis_g
      .selectAll('.tick line')
        .attr('x2', "0");
    
  var x_axis = d3.axisBottom(x_scale);
  var x_axis_g = g.append("g")
    .attr("class", "x axis")
    .attr("transform", "translate(0, " + height + ")")
    .call(x_axis);
  x_axis_g
    .selectAll('.tick')
    .attr('fill', "#635F5D");
  return(figure_container);
};

 