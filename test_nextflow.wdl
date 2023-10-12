version 1.0

workflow test_nextflow {
    input {
        File conf_gcp
    }

    call run_nextflow as run_nextflow_local {
    }

    call run_nextflow as run_nextflow_gcp {
        input:
            conf = conf_gcp
    }

    output {
        File out_local = run_nextflow_local.out
        File out_gcp = run_nextflow_gcp.out
    }
}

task run_nextflow {
    input {
        File? conf
    }
    command {
        unset "_JAVA_OPTIONS"
        nextflow run "https://github.com/nextflow-io/hello" ~{"-c " + conf} > out.txt
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
