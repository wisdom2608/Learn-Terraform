#!/bin/bash
cat <<'EOF' > /home/ubuntu/node_exporter.sh
${node_exporter}
EOF

chmod +x /home/ubuntu/node_exporter.sh 

/home/ubuntu/node_exporter.sh