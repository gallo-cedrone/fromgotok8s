package main

import (
	"fmt"
	"github.com/spf13/viper"
	"strings"
)

func config() {
	viper.SetEnvPrefix("FROMGOTOK8S")
	viper.AutomaticEnv()
	viper.SetEnvKeyReplacer(strings.NewReplacer("-", "_", ".", "_"))
	viper.SetDefault("url.google", "https://google.com")

	fmt.Print(viper.AllKeys())
}
