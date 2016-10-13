package tm1

import (
	"bytes"
)

// Dimension defines the structure of a single Dimension entity in the TM1 Server schema
type Dimension struct {
	Name        string
	Hierarchies []Hierarchy
}

// NewDimension creates a new Dimension object, with the specified name, and returns the dimension
func NewDimension(name string) *Dimension {
	return &Dimension{Name: name}
}

// NewHierarchy creates a new Hierarchy in the specified dimension, with the specified name, and returns the hierarchy
func (dimension *Dimension) NewHierarchy(name string) *Hierarchy {
	dimension.Hierarchies = append(dimension.Hierarchies, Hierarchy{Name: name})
	hierarchy := &dimension.Hierarchies[len(dimension.Hierarchies)-1]
	hierarchy.Captions = make(map[string]string)
	return hierarchy
}

// GetAttributesJSON returns the JSON specification to be passed to the Update action to update the attributes cube associated to the dimension
func (dimension *Dimension) GetAttributesJSON() string {
	return dimension.Hierarchies[0].GetAttributesJSON(dimension.Name)
}

// Hierarchy defines the structure of a single Hierarchy entity in the TM1 Server schema
type Hierarchy struct {
	Name     string
	Elements []Element
	Edges    []Edge            `json:",omitempty"`
	Captions map[string]string `json:"-"`
}

// NewElement creates a new Element in the specified Hierarchy, with the specified name, and returns the element
func (hierarchy *Hierarchy) NewElement(name, caption string) *Element {
	hierarchy.Elements = append(hierarchy.Elements, Element{Name: name})
	if caption != "" {
		hierarchy.Captions[name] = caption
	}
	return &hierarchy.Elements[len(hierarchy.Elements)-1]
}

// NewEdge creates a new Edge in the specified Hierarchy, linking the specified parent and component, and returns the edge
func (hierarchy *Hierarchy) NewEdge(parent *Element, component *Element) *Edge {
	hierarchy.Edges = append(hierarchy.Edges, Edge{ParentName: parent.Name, ComponentName: component.Name, Weight: 1.0})
	return &hierarchy.Edges[len(hierarchy.Edges)-1]
}

// GetAttributesJSON returns the JSON specification to be passed to the Update action to update the attributes cube associated to the dimension
func (hierarchy *Hierarchy) GetAttributesJSON(dimensionName string) string {
	var jAttributes bytes.Buffer
	var bFirst = true
	jAttributes.WriteString("[")
	for element, caption := range hierarchy.Captions {
		if bFirst == true {
			bFirst = false
		} else {
			jAttributes.WriteString(",")
		}
		jAttributes.WriteString(`{"Slice@odata.bind":["Dimensions('`)
		jAttributes.WriteString(dimensionName)
		jAttributes.WriteString(`')/Hierarchies('`)
		jAttributes.WriteString(dimensionName)
		jAttributes.WriteString(`')/Elements('`)
		jAttributes.WriteString(element)
		jAttributes.WriteString(`')","Dimensions('}ElementAttributes_`)
		jAttributes.WriteString(dimensionName)
		jAttributes.WriteString(`')/Hierarchies('}ElementAttributes_`)
		jAttributes.WriteString(dimensionName)
		jAttributes.WriteString(`')/Elements('Caption')"],"Value":"`)
		jAttributes.WriteString(caption)
		jAttributes.WriteString(`"}`)
	}
	jAttributes.WriteString("]")
	return jAttributes.String()
}

// Element defines the structure of a single Element entity in the TM1 Server schema
type Element struct {
	Name string
}

// Edge defines the structure of a single Edge entity in the TM1 Server schema
type Edge struct {
	ParentName    string
	ComponentName string
	Weight        float64
}

// CubePost defines the structure of a single Cube entity with the JSON annotations for POSTing (read: creating) one
type CubePost struct {
	Name         string
	DimensionIds []string `json:"Dimensions@odata.bind"`
	Rules        string   `json:",omitempty"`
}
