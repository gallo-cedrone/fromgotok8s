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
	cmdLine = append(cmdLine, "exec", "-i", "-e", "FROMGOTOK8S_URL_GOOGLE=http://web")

	cmdLine = append(cmdLine, "integration_fromgotok8s")
	cmdLine = append(cmdLine, "/fromgotok8s")

	cmd := exec.Command("docker", cmdLine...)

	var outbuf, errbuf bytes.Buffer
	cmd.Stdout = &outbuf
	cmd.Stderr = &errbuf

	err := cmd.Run()
	out := outbuf.String()
	errOut := errbuf.String()

	assert.Equal(t, "200", out)
	assert.Nil(t, err)
	assert.Equal(t, "", errOut)
}

func TestMainFunctionError(t *testing.T) {

	var cmdLine []string
	cmdLine = append(cmdLine, "exec", "-i", "-e", "FROMGOTOK8S_URL=http://notExisting")

	cmdLine = append(cmdLine, "integration_fromgotok8s")
	cmdLine = append(cmdLine, "/fromgotok8s")

	cmd := exec.Command("docker", cmdLine...)

	var outbuf, errbuf bytes.Buffer
	cmd.Stdout = &outbuf
	cmd.Stderr = &errbuf

	err := cmd.Run()
	out := outbuf.String()
	errOut := errbuf.String()

	assert.Equal(t, "", out)
	assert.Nil(t, err)
	assert.Equal(t, "Get http://notExisting: dial tcp: lookup notExisting on 127.0.0.11:53: no such host", errOut)
}
