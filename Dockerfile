
FROM alpine:latest

ENV CONFIG_JSON1={\"log\":{\"access\":\"\",\"error\":\"\",\"loglevel\":\"error\"},\"inbound\":{\"protocol\":\"vmess\",\"port\": 
ENV CONFIG_JSON2=,\"settings\":{\"clients\":[{\"id\":\" 
ENV CONFIG_JSON3=\",\"alterId\":64}]},\"streamSettings\":{\"network\":\"ws\",\"wsSettings\":{\"path\":\"
ENV CONFIG_JSON4=\",\"connectionReuse\":false}}},\"inboundDetour\":[],\"outbound\":{\"protocol\":\"freedom\",\"settings\":{}},\"transport\":
ENV CONFIG_JSON5={\"tcpSettings\":{\"connectionReuse\":false},\"wsSettings\":{\"connectionReuse\":false},\"tlsSettings\":{\"allowInsecure\":false}}}

ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

CMD /entrypoint.sh
