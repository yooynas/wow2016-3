package processes

import (
	"encoding/json"
	"log"
	"strconv"

	"github.com/hubert-heijkers/wow2016/hol3548/src/builder/helpers/odata"
	"github.com/hubert-heijkers/wow2016/hol3548/src/builder/northwind"
	"github.com/hubert-heijkers/wow2016/hol3548/src/builder/tm1"
)

type employeeDimension struct {
	name           string
	dimension      *tm1.Dimension
	hierarchy      *tm1.Hierarchy
	allElement     *tm1.Element
	countryElement *tm1.Element
	regionElement  *tm1.Element
	cityElement    *tm1.Element
}

func (d *employeeDimension) processResponse(responseBody []byte) (int, string) {
	// Unmarshal the JSON response
	res := northwind.EmployeesResponse{}
	err := json.Unmarshal(responseBody, &res)
	if err != nil {
		log.Fatal(err)
	}

	// Process the collection of employees returned by the data source
	// PRESUMPTIONS:
	//  - NO DUPLICATE REGION NAMES (WHICH WORKS IN THIS EXAMPLE;-)
	//  - REGIONS CAN BE EMPTY IN WHICH CASE CITIES RESIDE UNDER COUNTRY
	//  - THERE ARE, FORTUNATELY FOR THIS EXAMPLE, NO DUPLICATE CITY NAMES EITHER
	if d.hierarchy == nil {
		if d.dimension == nil {
			d.dimension = tm1.CreateDimension(d.name)
		}
		d.hierarchy = d.dimension.AddHierarchy(d.name)
		d.allElement = d.hierarchy.AddElement("All", "All Employees")
	}
	for _, employee := range res.Employees {
		if d.countryElement == nil || d.countryElement.Name != employee.Country {
			d.countryElement = d.hierarchy.AddElement(employee.Country, "")
			d.hierarchy.AddEdge(d.allElement, d.countryElement)
			if employee.Region != "" {
				d.regionElement = d.hierarchy.AddElement(employee.Region, "")
				d.hierarchy.AddEdge(d.countryElement, d.regionElement)
			} else {
				d.regionElement = nil
			}
			d.cityElement = d.hierarchy.AddElement(employee.City, "")
			if d.regionElement != nil {
				d.hierarchy.AddEdge(d.regionElement, d.cityElement)
			} else {
				d.hierarchy.AddEdge(d.countryElement, d.cityElement)
			}
		} else if (d.regionElement == nil && employee.Region != "") || (d.regionElement != nil && d.regionElement.Name != employee.Region) {
			if employee.Region != "" {
				d.regionElement = d.hierarchy.AddElement(employee.Region, "")
				d.hierarchy.AddEdge(d.countryElement, d.regionElement)
			} else {
				d.regionElement = nil
			}
			d.cityElement = d.hierarchy.AddElement(employee.City, "")
			if d.regionElement != nil {
				d.hierarchy.AddEdge(d.regionElement, d.cityElement)
			} else {
				d.hierarchy.AddEdge(d.countryElement, d.cityElement)
			}
		} else if d.cityElement == nil || d.cityElement.Name != employee.City {
			d.cityElement = d.hierarchy.AddElement(employee.City, "")
			if d.regionElement != nil {
				d.hierarchy.AddEdge(d.regionElement, d.cityElement)
			} else {
				d.hierarchy.AddEdge(d.countryElement, d.cityElement)
			}
		}
		d.hierarchy.AddEdge(d.cityElement, d.hierarchy.AddElement(strconv.Itoa(employee.ID), employee.LastName+", "+employee.FirstName))
	}

	// Return the nextLink, if there is one
	return res.Count, res.NextLink
}

// GenerateEmployeeDimension generates, based on the data from the northwind database, the dimension definition for the employees dimension
func GenerateEmployeeDimension(client *odata.Client, datasourceServiceRootURL string, name string) *tm1.Dimension {
	dimEmployees := &employeeDimension{name: name}
	client.IterateCollection(datasourceServiceRootURL, "Employees?$select=EmployeeID,LastName,FirstName,TitleOfCourtesy,City,Region,Country&$orderby=Country%20asc,Region%20asc,City%20asc", dimEmployees.processResponse)
	return dimEmployees.dimension
}
