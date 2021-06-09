.onLoad <- function(libname, pkgname) {

  # Create cached version of the hmd.mx function from the demography package
  gdt_hmd_mx_cached <<- memoise::memoise(demography::hmd.mx)
}
