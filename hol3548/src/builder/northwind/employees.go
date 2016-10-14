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

// EmployeeCollectionResponse defines the structure of an odata compliant response wrapping a employee collection
type EmployeeCollectionResponse struct {
	Context   string     `json:"@odata.context"`
	Count     int        `json:"@odata.count"`
	Employees []Employee `json:"value"`
	NextLink  string     `json:"@odata.nextLink"`
}
