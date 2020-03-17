package main

import (
	"fmt"
	"github.com/spf13/viper"
	"net/http"
	"os"
	"strings"
	"time"
)

func main() {
	config()
	stop := make(chan os.Signal, 1)
	startServer()
	<-stop
}

func startServer() *http.Server {
	var resp *http.Response
	var err error
	for range [3]int{} {
		resp, err = http.Get(viper.GetString("url.google"))

		time.Sleep(1 * time.Second)
	}
	if err != nil {
		panic(err.Error())
	}
	defer resp.Body.Close()

	viper.Set("resp.Code", resp.StatusCode)

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

func config() {
	viper.SetEnvPrefix("FROMGOTOK8S")
	viper.AutomaticEnv()
	viper.SetEnvKeyReplacer(strings.NewReplacer("-", "_", ".", "_"))
	viper.SetDefault("url.google", "https://google.com")

	fmt.Print(viper.AllKeys())
}
