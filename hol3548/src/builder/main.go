package main

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
	"net/http/cookiejar"
	"os"

	"github.com/hubert-heijkers/wow2016/hol3548/src/builder/helpers/odata"
	proc "github.com/hubert-heijkers/wow2016/hol3548/src/builder/processes"
	"github.com/hubert-heijkers/wow2016/hol3548/src/builder/tm1"
	"github.com/joho/godotenv"
)

// Environment variables
var datasourceServiceRootURL string
var tm1ServiceRootURL string

// Const defines
const productDimensionName = "Products"
const customerDimensionName = "Customers"
const employeeDimensionName = "Employees"
const timeDimensionName = "Time"
const measuresDimensionName = "Measures"
const ordersCubeName = "Orders"

// The http client, extended with some odata functions, we'll use throughout.
var client *odata.Client

/*
func executeGETRequest(urlStr string) *http.Response {
	// Create new, GET, request
	req, _ := http.NewRequest("GET", urlStr, nil)
	// We'll be expecting a JSON formatted response, set Accept header accordingly
	req.Header.Add("Accept", "application/json")
	fmt.Println(req.Method, req.URL)
	// Execute the request
	resp, err := client.Do(req)
	// If no errors then return the response
	if err != nil {
		log.Fatal(err)
	}
	return resp
}

func executePOSTRequest(urlStr, contentType, body string) *http.Response {
	// Create new, POST, request
	req, _ := http.NewRequest("POST", urlStr, strings.NewReader(body))
	req.Header.Add("Content-Type", contentType)
	// We'll be expecting a JSON formatted response, set Accept header accordingly
	req.Header.Add("Accept", "application/json")
	fmt.Println(req.Method, req.URL)
	fmt.Println(body)
	// Execute the request
	resp, err := client.Do(req)
	// If no errors then return the response
	if err != nil {
		log.Fatal(err)
	}
	return resp
}

func processCollection(urlStr string, processResponse func([]byte) (int, string)) {
	// Set up the request to retrieve the collection given the passed url
	// While we are requesting the collection completely in one request, the service might opt to
	// apply server driven paging and give us a partial response with a nextLink which subsequently
	// can be used to retrieve the next chunk or remainder of the collection. The following code
	// does exactly that however commented out because the implementation of the NorthWind service
	// has a big in the server driven paging algorithm resulting in entities getting lost.
	/ *
		for nextLink := urlStr; nextLink != ""; {
			resp := executeGETRequest(datasourceServiceRootURL + nextLink)
			defer resp.Body.Close()
			body, _ := ioutil.ReadAll(resp.Body)
			fmt.Println(string(body))

			// Process the response
			nextLink = processResponse(body)
		}
	* /
	// So instead we'll use paging driven by the client using $top and $skip using a small enough
	// page size so we don't inevitably run into a situation where the service would nevertheless
	// decide to page the result. For this purpose, and simplicity of the code, we've chosen a
	// page size of 10 and ignore any nextLink (which there won't be any guaranteed;-)
	// On the first request we'll add a $count query option asking the service the return the number
	// of entities we can expect in the total collection (hence the first request will take longer).
	url := urlStr + "&$count=true&$top=10"
	nCount := 0
	nSkip := 0
	for {
		resp := executeGETRequest(datasourceServiceRootURL + url)
		defer resp.Body.Close()
		body, _ := ioutil.ReadAll(resp.Body)
		fmt.Println(string(body))

		// Process the response
		count, _ := processResponse(body)
		if nCount == 0 {
			if count == 0 {
				break
			}
			nCount = count
		}
		nSkip += 10
		if nCount <= nSkip {
			break
		}
		url = urlStr + "&$skip=" + strconv.Itoa(nSkip) + "&$top=10"
	}
}
*/
// createDimension is the function that triggers the TM1 server to create the dimension
func createDimension(dimension *tm1.Dimension) string {
	// Create a JSON representation for the dimension
	jDimension, _ := json.Marshal(dimension)

	// POST the dimension to the TM1 server
	fmt.Println(">> Create dimension", dimension.Name)
	resp := client.ExecutePOSTRequest(tm1ServiceRootURL+"Dimensions", "application/json", string(jDimension))

	// Validate that the dimension got created successfully
	if resp.StatusCode != 201 {
		defer resp.Body.Close()
		body, _ := ioutil.ReadAll(resp.Body)
		log.Fatal("Failed to create dimension '" + dimension.Name + "'. Server responded with:\r\n" + string(body))
	} else {
		resp.Body.Close()
	}

	// Secondly create an element attribute named 'Caption' of type 'string'
	fmt.Println(">> Create 'Caption' attribute for dimension", dimension.Name)
	resp = client.ExecutePOSTRequest(tm1ServiceRootURL+"Dimensions('"+dimension.Name+"')/Hierarchies('"+dimension.Name+"')/ElementAttributes", "application/json", `{"Name":"Caption","Type":"String"}`)

	// Validate that the element attribute got created successfully as well
	if resp.StatusCode != 201 {
		defer resp.Body.Close()
		body, _ := ioutil.ReadAll(resp.Body)
		log.Fatal("Creating element attribute 'Caption' for dimension '" + dimension.Name + "' failed. Server responded with:\r\n" + string(body))
	} else {
		resp.Body.Close()
	}

	// Now that the caption attribute exists lets set the captions accordingly for this we'll
	// simply update the }ElementAttributes_DIMENSION cube directly, updating the default value.
	// Note: TM1 Server doesn't support passing the attribute values as part of the dimension
	// definition just yet (should shortly), so for now this is the easiest way around that
	// Alternatively one could have updated the attribute values for elements one by one by
	// POSTing to or PATCHing the LocalizedAttributes of the individual elements.
	fmt.Println(">> Set 'Caption' attribute values for elements in dimension", dimension.Name)
	resp = client.ExecutePOSTRequest(tm1ServiceRootURL+"Cubes('}ElementAttributes_"+dimension.Name+"')/tm1.Update", "application/json", dimension.GetAttributesJSON())

	// Validate that the update executed successfully (by default an empty response is expected, hence the 204).
	if resp.StatusCode != 200 && resp.StatusCode != 204 {
		defer resp.Body.Close()
		body, _ := ioutil.ReadAll(resp.Body)
		log.Fatal("Setting Caption values for elements in dimension '" + dimension.Name + "' failed. Server responded with:\r\n" + string(body))
	} else {
		resp.Body.Close()
	}

	// Return the odata.id of the generated dimension
	return "Dimensions('" + dimension.Name + "')"
}

// createCube is the function that, given a set of dimension Ids and rules, requests the TM1 server to create the cube
func createCube(name string, dimensionIds []string, rules string) string {

	//cube := &tm1.CubePost{Name: name, DimensionIds: dimensionIds, Rules: rules}
	jCube, _ := json.Marshal(tm1.CubePost{Name: name, DimensionIds: dimensionIds, Rules: rules})

	// POST the dimension to the TM1 server
	fmt.Println(">> Create cube", name)
	resp := client.ExecutePOSTRequest(tm1ServiceRootURL+"Cubes", "application/json", string(jCube))

	// Validate that the dimension got created successfully
	if resp.StatusCode != 201 {
		defer resp.Body.Close()
		body, _ := ioutil.ReadAll(resp.Body)
		log.Fatal("Failed to create cube '" + name + "'. Server responded with:\r\n" + string(body))
	} else {
		resp.Body.Close()
	}

	// Return the odata.id of the generated cube
	return "Cubes('" + name + "')"
}

func main() {
	// Load environment variables from .env file
	err := godotenv.Load()
	if err != nil {
		log.Fatal("Error loading .env file")
	}
	datasourceServiceRootURL = os.Getenv("DATASOURCE_SERVICE_ROOT_URL")
	tm1ServiceRootURL = os.Getenv("TM1_SERVICE_ROOT_URL")

	// Create the one and only http client we'll be using, with a cookie jar enabled to keep reusing our session
	cookieJar, _ := cookiejar.New(nil)
	client = &odata.Client{}
	client.Jar = cookieJar

	// Validate that the TM1 server is accessable by requesting the version of the server
	req, _ := http.NewRequest("GET", tm1ServiceRootURL+"Configuration/ProductVersion/$value", nil)

	// Since this is our initial request we'll have to provide a user name and password, also stored in the .env file, to authenticate
	// Note: using authentication mode 1, TM1 authentication, here which maps to basic authentication in HTTP[S]
	req.SetBasicAuth(os.Getenv("TM1_USER"), os.Getenv("TM1_PASSWORD"))

	// We'll expect text back in this case but we'll simply dump the content out and won't do any content type verification here
	req.Header.Add("Accept", "*/*")

	// Let's execute the request
	resp, err := client.Do(req)
	if err != nil {
		// Execution of the request failed, log the error and terminate
		log.Fatal(err)
	}

	// The body simply contains the version number of the server
	version, _ := ioutil.ReadAll(resp.Body)
	resp.Body.Close()

	// which we'll simply dump to the console
	fmt.Println("Using TM1 Server version", string(version))

	// Note that as a result of this request a TM1SessionId cookie was added to the cookie jar which will automatically be
	// reused on subsequent requests to our TM1 server, and therefore don't need to send the credentials over and over again.

	// Now let's build some Dimensions
	// The definition of the dimension is based on data in the northwind database, a data source hosted on
	// odata.org which, as one might have already gathered, can be queried using an OData compliant REST API.
	var dimensionIds [5]string
	dimensionIds[0] = createDimension(proc.GenerateProductDimension(client, datasourceServiceRootURL, productDimensionName))
	dimensionIds[1] = createDimension(proc.GenerateCustomerDimension(client, datasourceServiceRootURL, customerDimensionName))
	dimensionIds[2] = createDimension(proc.GenerateEmployeeDimension(client, datasourceServiceRootURL, employeeDimensionName))
	dimensionIds[3] = createDimension(proc.GenerateTimeDimension(client, datasourceServiceRootURL, timeDimensionName))
	dimensionIds[4] = createDimension(proc.GenerateMeasuresDimension(client, datasourceServiceRootURL, measuresDimensionName))

	// Now that we have all our dimensions, let's create cube
	createCube(ordersCubeName, dimensionIds[:], "UNDEFVALS;\nSKIPCHECK;\n\n['UnitPrice']=['Revenue']\\['Quantity'];\n\nFEEDERS;\n['Quantity']=>['UnitPrice'];")

	// Load the data in the cube
	proc.LoadOrderData(client, datasourceServiceRootURL, tm1ServiceRootURL, ordersCubeName, productDimensionName, customerDimensionName, employeeDimensionName, timeDimensionName, measuresDimensionName)

	// And we are done!
	fmt.Println(">> Done! Dimensions created, Cube created and Data loaded successfully!")
}
