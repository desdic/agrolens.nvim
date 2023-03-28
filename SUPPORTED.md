# Supported tree-sitter language/file formats

Languages

| Tree-sitter | functions | callings | comments 
| ----------- | ----------- | ----------- | --- |
| c | x | x | x |
| cpp | x | x | x |
| glsl | x | x | x |
| go | x | x | x |
| lua | x | x | x
| perl | x | x | x
| php | x | x* | x
| python | x | x | x
| ruby | x | x | x
| rust | x | x** | x

\* calling of functions in print/echo is currently not supported.

\** calling of functions in macros line println! is currently not supported.

Formats

| Tree-sitter | labels |
| ----------- | --- |
| make | x |
| markdown | x |
| toml | x |
| yaml | x* |


\* docker-compose.yml is the only one supported yet
