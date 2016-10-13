package northwind

// Customer defines the structure of A single Customer entity
type Customer struct {
	ID      string `json:"CustomerID"`
	Name    string `json:"CompanyName"`
	City    string
	Region  string
	Country string
}

// CustomerCollection defines the structure of a collection of the Customer entity
type CustomerCollection struct {
	Customers []Customer `json:"value"`
}

// CustomersResponse defines the structure of an odata compliant response wrapping a customer collection
type CustomersResponse struct {
	CustomerCollection
	Context  string `json:"@odata.context"`
	Count    int    `json:"@odata.count"`
	NextLink string `json:"@odata.nextLink"`
}
