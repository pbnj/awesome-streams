package main

import (
	"bufio"
	"encoding/json"
	"html/template"
	"io/ioutil"
	"log"
	"os"
	"sort"
	"strings"

	"gopkg.in/yaml.v2"
)

const (
	StreamYAML = "streams.yaml"
	StreamJSON = "streams.json"
)

type LiveStream struct {
	Category  string     `json:"category" yaml:"category"`
	Streamers []Streamer `json:"streamers" yaml:"streamers"`
}

type Streamer struct {
	Name    string   `json:"name" yaml:"name"`
	Social  string   `json:"social" yaml:"social"`
	Streams Streams  `json:"streams" yaml:"streams"`
	Topics  []string `json:"topics" yaml:"topics"`
}

type Streams struct {
	Twitch  string `json:"twitch" yaml:"twitch"`
	YouTube string `json:"youtube" yaml:"youtube"`
}

func main() {
	fin, err := os.Open(StreamYAML)
	if err != nil {
		log.Fatalln("cannot open YAML file:", err)
	}
	defer fin.Close()

	data, err := ioutil.ReadAll(fin)
	if err != nil {
		log.Fatalln("cannot read file:", err)
	}

	var ls []LiveStream
	err = yaml.Unmarshal(data, &ls)
	if err != nil {
		log.Fatalln("cannot unmarshal YAML:", err)
	}

	// sort alphabetically by category
	sort.Slice(ls, func(i, j int) bool {
		return ls[i].Category < ls[j].Category
	})
	// sort alphabetically by streamer name
	for _, l := range ls {
		sort.Slice(l.Streamers, func(i, j int) bool {
			return strings.ToUpper(l.Streamers[i].Name) < strings.ToUpper(l.Streamers[j].Name)
		})
	}

	json, err := json.MarshalIndent(ls, "", "  ")
	if err != nil {
		log.Fatalln("cannot marshal JSON:", err)
	}

	err = ioutil.WriteFile(StreamJSON, json, 0644)
	if err != nil {
		log.Fatalln("cannot write JSON:", err)
	}

	// helper functions
	funcMap := template.FuncMap{
		"dashed": func(word string) string {
			word = strings.ToLower(word)
			word = strings.Replace(word, " ", "-", -1)
			word = strings.Replace(word, "/", "", -1)
			return word
		},
		"titled": strings.Title,
	}

	tmpl, err := template.New("readme.tmpl").Funcs(funcMap).ParseFiles("template/readme.tmpl")
	if err != nil {
		log.Fatalln("cannot parse template", err)
	}

	fout, err := os.Create("README.md")
	if err != nil {
		log.Fatalln("cannot create README:", err)
	}
	defer fout.Close()

	w := bufio.NewWriter(fout)
	err = tmpl.Execute(w, ls)
	if err != nil {
		log.Fatalln("cannot execute template:", err)
	}
	defer w.Flush()
}
