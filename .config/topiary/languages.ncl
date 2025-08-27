{
  languages = {
    openscad = {
      extensions = [ "scad" ],
      grammar = {
        source = {
          git = {
            git = "https://github.com/openscad/tree-sitter-openscad.git",
            rev = "acc196e969a169cadd8b7f8d9f81ff2d30e3e253",
            nixHash = "sha256-x6fU1yPhYfoXemjswk+yRHW+c5V6nJgesK5tunYE7MI="
          }
        }
      },
      indent = "    "
    }
  }
}