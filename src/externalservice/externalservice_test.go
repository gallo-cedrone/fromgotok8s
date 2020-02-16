package externalservice

import (
	"github.com/magiconair/properties/assert"
	"testing"
)

func TestMainFunction(t *testing.T) {
	assert.Panic(t, testFunction, "unsupported protocol scheme \"\"")
}

func testFunction() {
	googleDependency := GoogleDependency{}
	googleDependency.CallDependencies()
}
