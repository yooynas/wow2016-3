package processes

import (
	"github.com/hubert-heijkers/wow2016/hol3548/src/builder/helpers/odata"
	"github.com/hubert-heijkers/wow2016/hol3548/src/builder/tm1"
)

// GenerateMeasuresDimension generates, based on the data from the northwind database, the dimension definition for the time dimension
func GenerateMeasuresDimension(client *odata.Client, datasourceServiceRootURL string, name string) *tm1.Dimension {
	// Build the measures dimension definition which simply contains three measures: Quantity, UnitPrice and Revenue
	dimension := tm1.CreateDimension(name)
	hierarchy := dimension.AddHierarchy(name)
	hierarchy.AddElement("Quantity", "")
	hierarchy.AddElement("UnitPrice", "Unit Price")
	hierarchy.AddElement("Revenue", "")
	return dimension
}
