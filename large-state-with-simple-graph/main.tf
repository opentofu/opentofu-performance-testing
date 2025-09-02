resource "tfcoremock_simple_resource" "copier" {
        count = 1000
        string = sensitive(file("./rdata.b64"))
}
