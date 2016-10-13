package northwind

// Product defines the structure of A single Product entity
type Product struct {
	ID   int    `json:"ProductID"`
	Name string `json:"ProductName"`
}

// Category defines the structure of A single Category entity
type Category struct {
	ID       int       `json:"CategoryID"`
	Name     string    `json:"CategoryName"`
	Products []Product `json:"Products"`
}

// CategoryCollection defines the structure of a collection of the Category entity
type CategoryCollection struct {
	Categories []Category `json:"value"`
}

// CategoriesResponse defines the structure of an odata compliant response wrapping a category collection
type CategoriesResponse struct {
	CategoryCollection
	Context  string `json:"@odata.context"`
	Count    int    `json:"@odata.count"`
	NextLink string `json:"@odata.nextLink"`
}
