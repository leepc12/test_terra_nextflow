version 1.0

workflow test_nextflow {
    input {
        File? conf_google_batch
        File? conf_papi
    }

    call run_nextflow as run_nextflow_local {
    }

    call run_nextflow as run_nextflow_papi {
        input:
            conf = conf_papi,
            nxf_mode = "google"
    }

    call run_nextflow as run_nextflow_google_batch {
        input:
            conf = conf_google_batch
    }

    output {
        File out_local = run_nextflow_local.out
        File out_google_batch = run_nextflow_google_batch.out
        File out_google_papi = run_nextflow_papi.out
    }
}

task run_nextflow {
    input {
        File? conf
        String? nxf_ver
        String? nxf_mode
    }
    command {
        unset "_JAVA_OPTIONS"
        ~{"export NXF_VER=" + nxf_ver}
        ~{"export NXF_MODE=" + nxf_mode}
        export NXF_DEBUG=3

        echo "Printing GOOGLE_APPLICATION_CREDENTIALS..."
        echo "$GOOGLE_APPLICATION_CREDENTIALS"

        echo "Printing gcloud auth list..."
        gcloud auth list

        echo "Printing contents of ~/.config/gcloud/"
        ls -l ~/.config/gcloud/

        echo "Running Nextflow..."
        nextflow run "https://github.com/nextflow-io/hello" ~{"-c " + conf} > out.txt
        cat .nextflow.log
    }
    output {
        File out = "out.txt"
        #File log = ".nextflow.log"
    }
    runtime {
        docker: "nextflow/nextflow"
        cpu: 1
        memory: "4 GB"
        disks: "local-disk 10 SSD"
    }
}
