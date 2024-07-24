resource "tfcoremock_simple_resource" "iter" {
  count  = 1
  string = count.index
}
