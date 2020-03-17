package main

import (
	"fmt"
	"github.com/gallo-cedrone/fromgotok8s/src/externalService"
	"github.com/spf13/viper"
	"net/http"
	"os"
)

func main() {
	config()
	stop := make(chan os.Signal, 1)
	startServer(externalService.GoogleDependency{})
	<-stop
}

func startServer(dependency externalService.DependencyCaller) *http.Server {

	viper.Set("resp.Code", dependency.CallDependencies())
	server := &http.Server{
		Addr:    ":8080",
		Handler: handlerExample{},
	}

	go func() {
		server.ListenAndServe()
	}()
	return server
}

type handlerExample struct{}

func (h handlerExample) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "%s answered with statusCode: %d", viper.GetString("url.google"), viper.GetInt32("resp.Code"))
}
