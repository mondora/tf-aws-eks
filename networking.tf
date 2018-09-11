data "aws_availability_zones" "available" {}
resource "aws_vpc" "mondoraeksvpc" {
  cidr_block = "172.16.0.0/16"

  tags = "${
    map(
     "env", "${var.environment}",
     "Name", "${var.service_name}-${var.location}-vpc",
     "kubernetes.io/cluster/${var.service_name}", "shared",
    )
  }"
}
resource "aws_subnet" "mondoraekssubnet" {
  count = 2

  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
  cidr_block        = "172.16.${count.index}.0/24"
  vpc_id            = "${aws_vpc.mondoraeksvpc.id}"

  tags = "${
    map(
     "env", "${var.environment}",
     "Name", "${var.service_name}-${var.location}-subnet${count.index}",
     "kubernetes.io/cluster/${var.service_name}", "shared",
    )
  }"
}

resource "aws_internet_gateway" "mondoraeksigw" {
  vpc_id = "${aws_vpc.mondoraeksvpc.id}"

  tags {
    Name = "${var.service_name}-${var.location}-igw"
    env = "${var.environment}"
  }
}

resource "aws_route_table" "mondoraeksrt" {
  vpc_id = "${aws_vpc.mondoraeksvpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.mondoraeksigw.id}"
  }
}

resource "aws_route_table_association" "mondoraeksrta" {
  count = 2

  subnet_id      = "${aws_subnet.mondoraekssubnet.*.id[count.index]}"
  route_table_id = "${aws_route_table.mondoraeksrt.id}"
}