package main

import (
	"encoding/json"
	"encoding/xml"
	"fmt"
	"io/ioutil"
	"os"
	"path/filepath"
)

type SSLReponse struct {
	Host            string
	Protocol        string
	CriteriaVersion string
	IsPublic        bool
	Status          string
	StartTime       int
	TestTime        int
	EngineVersion   string
	Endpoints       []SSLEndpoints
}

type SSLEndpoints struct {
	IpAddress         string
	ServerName        string
	StatusMessage     string
	Grade             string
	GradeTrustIgnored string
	HasWarnings       bool
	IsExceptional     bool
	Progress          int
	Duration          int
	Delegation        int
	Details           SSLDetails
}

type SSLDetails struct {
	HostStartTime              int
	ServerSignature            string
	PrefixDelegation           bool
	NonPrefixDelegation        bool
	VulnBeast                  bool
	RenegSupport               int
	SessionResumption          int
	CompressionMethods         int
	SupportsNpn                bool
	SupportsAlpn               bool
	AlpnProtocols              string
	SessionTickets             int
	OcspStapling               bool
	StaplingRevocationStatus   int
	SniRequired                bool
	HttpStatusCode             int
	SupportsRc4                bool
	Rc4WithModern              bool
	Rc4Only                    bool
	ForwardSecrecy             int
	SupportsAead               bool
	ProtocolIntolerance        int
	MiscIntolerance            int
	Heartbleed                 bool
	Heartbeat                  bool
	OpenSslCcs                 int
	OpenSSLLuckyMinus20        int
	Ticketbleed                int
	Bleichenbacher             int
	Poodle                     bool
	PoodleTls                  int
	FallbackScsv               bool
	Freak                      bool
	HasSct                     int
	DhUsesKnownPrimes          int
	DhYsReuse                  bool
	EcdhParameterReuse         bool
	Logjam                     bool
	DrownErrors                bool
	DrownVulnerable            bool
	ImplementsTLS13MandatoryCS bool
	ZeroRTTEnabled             int
	ZombiePoodle               int
	GoldenDoodle               int
	SupportsCBC                bool
	ZeroLengthPaddingOracle    int
	SleepingPoodle             int
	NamedGroups                SSLNamedGroups
	Suites                     []SSLSuites
	Protocols                  []SSLProtocols
	Sims                       SSLSims
}

type SSLNamedGroups struct {
	List []struct {
		Id             int
		Name           string
		Bits           int
		NamedGroupType string
	}
	Preference bool
}

type SSLSuites struct {
	Protocol int
	List     []struct {
		Id             int
		Name           string
		CipherStrength int
		KxType         string
		KxStrength     int
		DhBits         int
		DhP            int
		DhG            int
		DhYs           int
	}
}

type SSLProtocols struct {
	Id      int
	Name    string
	Version string
}

type SSLSims struct {
	Results []struct {
		Client struct {
			Id          int
			Name        string
			Version     string
			IsReference bool
		}
		ErrorCode    int
		ErrorMessage string
		Attempts     int
	}
}

/*
 *
 */

var cheminTest = "test"

func main() {
	err := ConvertJSONtoXML("geba_fr.json", "geba_fr.xml")
	if err != nil {
		fmt.Println("Erreur lors de la conversion :", err)
		return
	}

	fmt.Println("Conversion terminée avec succès.")
}

func ConvertJSONtoXML(inputFile, outputFile string) error {
	// Lire le fichier JSON en entrée
	var fileIn = filepath.Join(cheminTest, "geba_fr.json")
	var fileOut = filepath.Join(cheminTest, "geba_fr.xml")
	jsonFile, err := os.Open(fileIn)
	// jsonFile, err := os.Open(cheminTest + os.PathSeparator + inputFile)
	if err != nil {
		return fmt.Errorf("erreur lors de l'ouverture du fichier JSON: %v", err)
	}
	defer jsonFile.Close()
	fmt.Println("Fin lecture")

	byteValue, _ := ioutil.ReadAll(jsonFile)

	// Déclarer une structure générique pour le JSON
	var SSLdata []SSLReponse

	// Convertir le JSON en structure Go
	err = json.Unmarshal(byteValue, &SSLdata)
	if err != nil {
		return fmt.Errorf("erreur lors de la conversion JSON en structure Go: %v", err)
	}

	fmt.Println("Fin unmarshalling")

	// Convertir la structure Go en XML
	xmlData, err := xml.MarshalIndent(SSLdata, "", "    ")
	if err != nil {
		return fmt.Errorf("erreur lors de la conversion en XML: %v", err)
	}

	// Écrire le résultat XML dans un fichier
	xmlFile, err := os.Create(fileOut)
	if err != nil {
		return fmt.Errorf("erreur lors de la création du fichier XML: %v", err)
	}
	defer xmlFile.Close()

	xmlFile.Write([]byte(xml.Header))
	xmlFile.Write(xmlData)

	return nil
}
