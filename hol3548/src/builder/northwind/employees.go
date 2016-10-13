package northwind

// Employee defines the structure of A single Employee entity
type Employee struct {
	ID              int `json:"EmployeeID"`
	TitleOfCourtesy string
	FirstName       string
	LastName        string
	City            string
	Region          string
	Country         string
}

// EmployeeCollection defines the structure of a collection of the Employee entity
type EmployeeCollection struct {
	Employees []Employee `json:"value"`
}

// EmployeesResponse defines the structure of an odata compliant response wrapping a employee collection
type EmployeesResponse struct {
	EmployeeCollection
	Context  string `json:"@odata.context"`
	Count    int    `json:"@odata.count"`
	NextLink string `json:"@odata.nextLink"`
}
