#' World TopoJSON
#'
#' @returns A TopoJSON object
#'
#' @export
#' @examples gdt_world_topojson()
gdt_world_topojson <- function() {
  geojsonio::geojson_read(
    system.file("extdata/gis/world-highres2.topo.json", package = "geodata"),
  )
}
