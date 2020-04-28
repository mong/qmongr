//figure margin that takes in svg to place the margin 
//and a params with a margin_px object containing the
//amount of top,  bottom, right and left margins in px 
// and the width and height to place the title margin 
var  responsive_margin = function (selection, params) {
  var {
    margin_px,
    width,
    height,
    class_name = "margin_group" 
  } = params;

  var title_margin = selection.selectAll(".title_margin").data([null]);
  title_margin = title_margin
    .enter()
    .append("g")
    .merge(title_margin)
      .attr("class", "title_margin");

  var top_margin = title_margin.selectAll('rect').data([null]);
  top_margin = top_margin
    .enter().append('rect')
    .merge(top_margin)
      .attr('width', width-20)
      .attr('height', height * 0.15)
      .attr("x",0)
      .attr("y",height*0.02)
      .attr("fill", "#eaf7fc")
      .attr("stroke","white")
      .attr("stroke-width", "1px");

  var title = title_margin.selectAll(".table_figure_title").data([null]);
  title 
    .enter().append("text")
    .merge(title)
      .attr("class", "table_figure_title")
      .attr("x", width* 0.025)
      .attr("y", height * 0.09)
      .text("This is the title")
      .attr("fill", "#635F5D")
      .style("font-size", height/15 + "px")
      .style("font-weight","400")
      .style("font-family", "Book Antiqua, Georgia, sans-serif");
  
  var sub_title = title_margin.selectAll(".table_figure_subtitle").data([null]);
  sub_title 
    .enter().append("text")
    .merge(sub_title)
      .attr("class", "table_figure_subtitle")
      .attr("x", width* 0.025)
      .attr("y", height * 0.15)
      .text("This is the sub title of the figure below ")
      .attr("fill", "#8E8883")
      .style("font-size", height/30 + "px")
      .style("font-weight","200")
      .style("font-style","italic")
      .style("font-family", "georgia, sans-serif");

  var g = selection.selectAll("." + class_name)
    .data([null]);
  g = g 
    .enter()
    .append("g")
    .attr("class", class_name)
    .merge(g)
      .attr("transform", "translate(" + margin_px.left + " ," + margin_px.top  + ")");
  return(g);
};
