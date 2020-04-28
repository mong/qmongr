var labeled_x_axis_linear = function (selection, props){
  var {
    x_scale,
    x_axis_label,
    x_axis_label_fill,
    x_axis_label_offset ,
    x_axis_label_font_size,
    x_axis_tick_font_size,
    x_axis_tick_font_fill,
    x_axis_tick_line_stroke,
    x_axis_tick_density,
    x_axis_domain_line_stroke,
    inner_width,
    inner_height
  } = props;

  var x_axis = d3.axisBottom(x_scale)
    .ticks(inner_width / x_axis_tick_density);
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
      .attr('fill', x_axis_tick_font_fill);
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
      .style('font-size', x_axis_label_font_size)
      .style("font-family", "georgia, sans-serif");
};
 

var labeled_y_axis_linear = function (selection, props){
  var {
    y_scale,
    y_axis_label,
    y_axis_label_fill,
    y_axis_label_offset,
    y_axis_label_font_size,
    y_axis_tick_font_size,
    y_axis_tick_font_fill,
    y_axis_tick_line_stroke,
    y_axis_tick_density,
    y_axis_domain_line_stroke,
    inner_height
  } = props;

  var y_axis = d3.axisLeft(y_scale)
    .ticks(inner_height / y_axis_tick_density);
  var y_axis_g = selection.selectAll('.y-axis').data([null]);
  y_axis_g = y_axis_g
    .enter().append('g')
      .attr('class', 'y-axis')
    .merge(y_axis_g);
  y_axis_g.call(y_axis);
  y_axis_g
    .selectAll('.tick text')
      .style('font-size', y_axis_tick_font_size)
      .attr('fill', y_axis_tick_font_fill);
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
      .attr('x', -inner_height / 2)
      .attr('y', -y_axis_label_offset)
      .style('font-size', y_axis_label_font_size);
};


var labeled_y_axis_band = function (selection, props){
  var {
    y_scale,
    y_axis_label,
    y_axis_label_fill,
    y_axis_label_offset ,
    y_axis_label_font_size,
    y_axis_tick_font_size,
    y_axis_tick_font_fill,
    y_axis_tick_line_stroke,
    y_axis_tick_density,
    y_axis_domain_line_stroke,
    inner_width,
    inner_height,
    margin_px
  } = props;

  var y_axis = d3.axisLeft(y_scale)
  .ticks(inner_height / theme.y_axis_tick_density);
  var y_axis_g = selection.selectAll('.y-axis').data([null]);
  y_axis_g = y_axis_g
    .enter().append('g')
    .attr('class', 'y-axis')
    .merge(y_axis_g);

  y_axis_g.call(y_axis);
  y_axis_g
    .selectAll('.tick text')
    .style('font-size', theme.y_axis_tick_font_size)
    .attr('fill', theme.y_axis_tick_font_fill);
  y_axis_g
    .selectAll('.tick line')
    .attr('stroke', theme.y_axis_tick_line_stroke);
  y_axis_g
    .select('.domain')
    .attr('stroke', theme.y_axis_domain_line_stroke);
    
  var y_axis_label_text = y_axis_g.selectAll('.axis-label').data([null]);
  y_axis_label_text
    .enter().append('text')
    .attr('class', 'axis-label')
    .merge(y_axis_label_text)
      .attr('fill', theme.y_axis_label_fill)
      .text(theme.y_axis_label)
      .attr('transform', 'rotate(-90)')
      .attr('x', -inner_height / 2.3)
      .attr('y', -inner_width / 6)
      .style('font-size', margin_px.bottom/3 + "px");   

};