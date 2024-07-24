resource "tfcoremock_simple_resource" "iter" {
        count = 1000
        string = "${count.index}"
}

resource "tfcoremock_simple_resource" "iter2" {
        count = 1000
        string = "${tfcoremock_simple_resource.iter[count.index].string}"
}
