.onLoad <- function(libname, pkgname) {
  # Create cached version of some of the functions from the demography package
  gdt_hmd_mx_cached <<- memoise::memoise(demography::hmd.mx)
  gdt_hmd_e0_cached <<- memoise::memoise(demography::hmd.e0)
}
