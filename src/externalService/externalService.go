package externalService

import (
	"github.com/spf13/viper"
	"net/http"
	"time"
)

const maxRetries = 3

type DependencyCaller interface {
	CallDependencies() int
}

type GoogleDependency struct{}

func (g GoogleDependency) CallDependencies() int {
	var resp *http.Response
	var err error
	for i := 0; i < maxRetries; i++ {
		resp, err = http.Get(viper.GetString("url.google"))
		if err == nil {
			resp.Body.Close()
			return resp.StatusCode
		}
		time.Sleep(1 * time.Second)
	}
	panic(err.Error())
}

type MockGoogleDependency struct{}

func (mG MockGoogleDependency) CallDependencies() int {
	return 200
}
