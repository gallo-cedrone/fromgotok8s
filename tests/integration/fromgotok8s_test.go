// +build integration

package integration

import (
	"bytes"
	"github.com/stretchr/testify/assert"
	"os/exec"
	"testing"
)

func TestMainFunction(t *testing.T) {

	var cmdLine []string
	cmdLine = append(cmdLine, "exec", "-i")

	cmdLine = append(cmdLine, "simple_nginx_with_curl")
	cmdLine = append(cmdLine, "curl", "-s", "fromgotok8s:8080")

	cmd := exec.Command("docker", cmdLine...)

	var outbuf, errbuf bytes.Buffer
	cmd.Stdout = &outbuf
	cmd.Stderr = &errbuf

	err := cmd.Run()
	out := outbuf.String()
	errOut := errbuf.String()

	assert.Equal(t, "http://web answered with statusCode: 200", out)
	assert.Nil(t, err)
	assert.Equal(t, "", errOut)
}
