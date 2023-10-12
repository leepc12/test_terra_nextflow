version 1.0

workflow test_nextflow {
    input {
        File conf
    }

    call run_nextflow {
        input:
            conf = conf
    }

    output {
        File out = run_nextflow.out
    }
}

task run_nextflow {
    input {
        File conf
    }
    command {
        unset "_JAVA_OPTIONS"
        nextflow run "https://github.com/nextflow-io/hello" -c "~{conf}" > out.txt
    }
    output {
        File out = "out.txt"
    }
    runtime {
        docker: "nextflow/nextflow"
        cpu: 1
        memory: "4 GB"
        disks: "local-disk 10 SSD"
    }
}
