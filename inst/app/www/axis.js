var labeled_x_axis_linear = function (selection, props){
  var {
    x_scale,
    inner_width,
    inner_height,
    x_axis_label,
    x_axis_label_fill,
    x_axis_label_offset = inner_height/6 ,
    x_axis_label_font_size = 9 + inner_width * 0.04  + "px",
    x_axis_tick_font_size = 7+ inner_width *0.02  + "px",
    x_axis_tick_font_fill,
    x_axis_tick_line_stroke,
    x_axis_tick_number = 6,
    x_axis_tick_size = inner_height,
    x_axis_tick_offset = inner_height * 0.05,
    x_axis_domain_line_stroke,
    x_axis_label_font_family 
  } = props;

  var x_axis = d3.axisBottom(x_scale)
    .tickSize(-x_axis_tick_size)
    .ticks(x_axis_tick_number)
    .tickFormat(d3.format(",.0%"));

  var x_axis_g = selection.selectAll('.x-axis').data([null]);
  x_axis_g = x_axis_g
    .enter().append('g')
      .attr('class', 'x-axis')
    .merge(x_axis_g)
      .attr('transform', `translate(0,${inner_height})`);
  x_axis_g.call(x_axis);
    
  x_axis_g
    .selectAll('.tick text')
      .style('font-size',  x_axis_tick_font_size)
      .attr('fill', x_axis_tick_font_fill)
      .attr("y",x_axis_tick_offset );
      
  x_axis_g
    .selectAll('.tick line')
      .attr('stroke', x_axis_tick_line_stroke);
  x_axis_g
    .select('.domain')
      .attr('stroke', x_axis_domain_line_stroke);

  var x_axis_label_text = x_axis_g.selectAll('.axis-label').data([null]);
  x_axis_label_text
    .enter().append('text')
      .attr('class', 'axis-label')
    .merge(x_axis_label_text)
      .attr('fill', x_axis_label_fill)
      .text(x_axis_label)
      .attr('x', inner_width / 2)
      .attr('y', x_axis_label_offset)
      .style('font-size',  x_axis_label_font_size)
      .style("font-family",  x_axis_label_font_family);

};
 

var labeled_y_axis_linear = function (selection, props){
  var {
    y_scale,
    inner_width,
    inner_height,
    y_axis_label = "Y axis",
    y_axis_label_fill = "black",
    y_axis_label_offset = inner_width * 1.15,
    y_axis_label_font_size = 7 + inner_width * 0.02 + "px",
    y_axis_label_font_family = "arial",
    y_axis_tick_font_size = 8 + (inner_height * 0.02) + "px",
    y_axis_tick_distance_from_axis = 7 + (inner_width * 0.06),
    y_axis_tick_number,
    y_axis_tick_font_fill,
    y_axis_tick_line_stroke,
    y_axis_tick_size = inner_width,
    y_axis_domain_line_stroke,
    transition=false
  } = props;

  var y_axis = d3.axisRight(y_scale)
    .ticks(y_axis_tick_number)
    .tickSize( y_axis_tick_size)
    .tickFormat(d3.format(",.0%"));;
  var y_axis_g = selection.selectAll('.y-axis').data([null]);
  y_axis_g = y_axis_g
    .enter().append('g')
    .attr('class', 'y-axis')
    .merge(y_axis_g)
    
  transition ?
    y_axis_g.transition().delay(2000).duration(2000).call(y_axis).nice:
    y_axis_g.call(y_axis);
  
  y_axis_g
    .selectAll('.tick text')
    .style('font-size',  y_axis_tick_font_size)
    .attr('fill', y_axis_tick_font_fill)
 
  y_axis_g
    .selectAll('.tick line')
    .attr('stroke', y_axis_tick_line_stroke);
  y_axis_g
    .select('.domain')
    .attr('stroke', y_axis_domain_line_stroke);
    
  var y_axis_label_text = y_axis_g.selectAll('.axis-label').data([null]);
  y_axis_label_text
    .enter().append('text')
    .attr('class', 'axis-label')
    .merge(y_axis_label_text)
      .attr('fill', y_axis_label_fill)
      .text(y_axis_label)
        .attr('transform', 'rotate(-90)')
        .attr('x', -inner_height / 1.5)
        .attr('y', y_axis_label_offset)
        .style('font-size',y_axis_label_font_size)
        .style('font-family', y_axis_label_font_family);
};

var labeled_x_axis_time = function (selection, props){
  var {
    x_scale,
    inner_width,
    inner_height,
    x_axis_tick_values,
    x_axis_label = "",
    x_axis_label_fill = "",
    x_axis_label_offset = 0,
    x_axis_label_font_size = 0,
    x_axis_label_font_family = "arial",
    x_axis_tick_font_size = 10 + (inner_width * 0.015) + "px",
    x_axis_tick_distance_from_axis = 5 + (inner_height * 0.08),
    x_axis_tick_font_fill,
    x_axis_tick_line_stroke,
    x_axis_domain_line_stroke,
    x_axis_label_font_family,
  } = props;
  
  var x_axis = d3.axisBottom(x_scale)
    //.ticks(d3.timeYear.every()) 
    .tickValues(x_axis_tick_values)
    .tickFormat(d3.timeFormat("%Y"));
  var x_axis_g = selection.selectAll('.x-axis').data([null]);
  x_axis_g = x_axis_g
    .enter().append('g')
      .attr('class', 'x-axis')
    .merge(x_axis_g)
      .attr('transform', `translate(0,${inner_height})`);
  x_axis_g.call(x_axis);
  x_axis_g
    .selectAll('.tick text')
      .style('font-size', x_axis_tick_font_size)
      .attr('fill', x_axis_tick_font_fill)
      .attr("y",  x_axis_tick_distance_from_axis);
  x_axis_g
    .selectAll('.tick line')
      .attr('stroke', x_axis_tick_line_stroke);
  x_axis_g
    .select('.domain')
      .attr('stroke', x_axis_domain_line_stroke);

  var x_axis_label_text = x_axis_g.selectAll('.axis-label').data([null]);
  x_axis_label_text
    .enter().append('text')
      .attr('class', 'axis-label')
    .merge(x_axis_label_text)
      .attr('fill', x_axis_label_fill)
      .text(x_axis_label)
      .attr('x', inner_width / 2)
      .attr('y',x_axis_label_offset)
      .style('font-size',  x_axis_label_font_size + "px")
      .style("font-family",  x_axis_label_font_family);     
};

var color_legend_line_chart = function (selection, props){
  var {
    line_color_scale,
    margin = {left:0.1,right:0.1},
    inner_width,
    inner_height,
    position_left,
    legend_text_fill,
    legend_text_font_family,
    legend_text_font_size = 7 + inner_width * 0.01, 
    legend_text_offset = inner_width *0.02,
    legend_circle_radius = (15 + inner_width * 0.01)/2,
    legend_space_between_circles = inner_width * 0.25,
    legend_first_circle_offset =inner_width * 0.05

  } = props;
  

  var primary_legend_group = selection.selectAll(".line_chart_legend_table").data([null])
  var legend_container = primary_legend_group 
    .enter()
    .append("div")
    .merge(primary_legend_group)
      .attr("class", "line_chart_legend_table")
      .style("position", "relative")
      .style("top", "0")
      .style("left", `${margin.left * 100}%`)
      .style("width", `${(1-margin.left-margin.right) * 100}%`)
  var legend_list = legend_container.selectAll("ul").data([null])
    .enter()
    .append("ul")
    .merge(legend_container)
    .style("display","flex")
    .style("justify-content", "flex-start")
    .style("flex-wrap", "wrap")
  var legend = legend_list.selectAll("li").data(line_color_scale.domain())
  
  var legend_item = legend
    .enter()
    .append("li")
    .style("display", "inline-block")
    .style("margin", "5px")
    .style("display", "flex")
    .attr("class", "legend_item")
    
  legend.exit().remove() 
  
  legend_item
    .merge(legend)
    .on("mouseover", function(d){
      d3.selectAll(`svg path.table-line-chart:not(.clicked)`)
        .transition().duration(500)
        .style("opacity", 0.2)
      d3.select(`svg path.${d.replace(/\s/g, '')}`)
        .transition().duration(500)
        .style("opacity", 1)

      d3.select(this).style("cursor", "pointer")
    })
    .on("mouseout", function(d){
      var nr_clicked = d3.select(".responsive_svg")
          .selectAll("li.clicked").nodes().length
      if (nr_clicked < 1) {
        d3.selectAll(`path.table-line-chart:not(.clicked)`)
          .transition().duration(500)
          .style("opacity", 1)
        
      } else {
        d3.selectAll(`path.table-line-chart:not(.clicked)`)
          .transition().duration(500)
          .style("opacity", 0.2)
      }
    })
    .on("click", function(d){
      var clicked_legend = d3.select(this).attr("class") ;
       
      if (clicked_legend.includes("clicked")) {
        var nr_clicked = d3.select(".responsive_svg")
          .selectAll("li.clicked").nodes().length
   
        if (nr_clicked === 1){
          var selected_path_class =  d3.select(`svg path.${d.replace(/\s/g, '')}`)
            .attr("class")
          selected_path_class = selected_path_class.replace(" clicked", "")
          clicked_legend = clicked_legend.replace(" clicked", "")
            
          d3.selectAll(`svg path.table-line-chart`)
            .attr("class", d =>`table-line-chart  ${d.key.replace(/\s/g, '')}`)
            .transition().duration(1000)
            .style("opacity", 1)
          d3.selectAll(".responsive_svg li.legend_item")
            .attr("class", clicked_legend)
            .transition().duration(500)
            .style("opacity", 1) 
        } else if (nr_clicked > 1) {
          var selected_path_class =  d3.select(`svg path.${d.replace(/\s/g, '')}`)
            .attr("class")
          selected_path_class = selected_path_class.replace(" clicked", "")
          clicked_legend = clicked_legend.replace(" clicked", "")
          d3.select(`svg path.${d.replace(/\s/g, '')}`)
            .attr("class", selected_path_class)
            .transition().duration(1000)
            .style("opacity", "0.2")
          d3.select(this)
            .attr("class", clicked_legend)
            .transition().duration(500)
            .style("opacity", 0.4) 
        } else {
           var selected_path_class =  d3.select(`svg path.${d.replace(/\s/g, '')}`)
            .attr("class")
           selected_path_class = selected_path_class.replace(" clicked", "")
           clicked_legend = clicked_legend.replace(" clicked", "")
           d3.select(`svg path.table-line-chart`)
            .attr("class", selected_path_class)
            .transition().duration(1000)
            .style("opacity", 1)
          d3.select(".responsive_svg li.legend_item")
            .attr("class", clicked_legend)
            .transition().duration(500)
            .style("opacity", 1) 
          
        }
      } else {
        var nr_clicked = d3.select(".responsive_svg")
            .selectAll("li.clicked").nodes().length
          if (nr_clicked === 0){
            var selected_path_class =  d3.select(`svg path.${d.replace(/\s/g, '')}`)
              .attr("class")
             selected_path_class = `${selected_path_class} clicked`
             clicked_legend = `${clicked_legend} clicked`
             
             d3.select(`svg path.${d.replace(/\s/g, '')}`)
              .attr("class", selected_path_class)
              .style("opacity", 1)
            d3.select(this)
              .attr("class", clicked_legend)
              .style("opacity", 1) 
            d3.selectAll(`svg path.table-line-chart:not(.clicked)`)
              .transition().duration(500)
              .style("opacity", 0.2)
            d3.selectAll(".responsive_svg li.legend_item:not(.clicked)")
              .transition().duration(500)
              .style("opacity", 0.4)
           } else if(nr_clicked > 0){
              var selected_path_class =  d3.select(`svg path.${d.replace(/\s/g, '')}`)
              .attr("class")
             selected_path_class = `${selected_path_class} clicked`
             clicked_legend = `${clicked_legend} clicked`
             d3.select(`svg path.${d.replace(/\s/g, '')}`)
              .attr("class", selected_path_class)
              .style("opacity", 1)
            d3.select(this)
              .attr("class", clicked_legend)
              .style("opacity", 1) 
             
           }
        
      
      }
    })
    legend_item
      .append("text")
      .merge(legend.select("text"))
      .text(d => d)

      .style("font-size", legend_text_font_size + "px")
      .style("font-family", legend_text_font_family)
      .style("fill", legend_text_fill)
      .style("padding", "5px")
      .style("border-bottom",d => `3px solid ${line_color_scale(d)}`)
      
}

var y_axis_band = function (selection, props){
  var {
    y_scale,
    
    inner_width,
    inner_height,
    y_axis_label_font_family = "arial",
    y_axis_tick_font_size = 3 + (inner_height * 0.04) + "px",
    y_axis_tick_distance_from_axis = (inner_width * 0.03),
    y_axis_tick_font_fill,
    y_axis_tick_line_stroke,
    y_axis_domain_line_stroke,
  } = props;

  var y_axis = d3.axisLeft(y_scale)
 
  var y_axis_g = selection.selectAll('.y-axis').data([null]);
  y_axis_g = y_axis_g
    .enter().append('g')
    .attr('class', 'y-axis')
    .merge(y_axis_g)
      
  y_axis_g.call(y_axis)
    .attr("text-anchor", "end");
  y_axis_g
    .selectAll('.tick text')
    .attr("x", - y_axis_tick_distance_from_axis)
    .style('font-size', y_axis_tick_font_size)
    .style("font-family",y_axis_label_font_family)
    .attr('fill', y_axis_tick_font_fill);
  y_axis_g
    .selectAll('.tick line')
    .attr('stroke', y_axis_tick_line_stroke);
  y_axis_g
    .select('.domain')
    .attr('stroke', y_axis_domain_line_stroke);
    
  
}