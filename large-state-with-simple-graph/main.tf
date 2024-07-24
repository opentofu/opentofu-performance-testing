resource "tfcoremock_simple_resource" "copier" {
        count = 1000
        string = file("./rdata.b64")
}
