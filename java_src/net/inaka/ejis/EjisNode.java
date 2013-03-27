package net.inaka.ejis;

import java.io.IOException;
import java.util.logging.Logger;

import com.ericsson.otp.erlang.OtpNode;
import com.ericsson.otp.stdlib.OtpGenServer;

/**
 * @author Fernando Benavides <elbrujohalcon@inaka.net> Main node for Ejis
 *         Server
 */
public class EjisNode {
	private static final Logger	jlog	= Logger.getLogger(EjisNode.class
												.getName());

	/**
	 * This Erlang node
	 */
	public static OtpNode		NODE;

	/**
	 * Peer node name
	 */
	public static String		PEER;

	/**
	 * Start up function
	 * 
	 * @param args
	 *            Command line arguments: [name] [cookie]
	 */
	public static void main(String[] args) {
		String peerName = args.length >= 1 ? args[0]
				: "lucene_server@localhost";
		String nodeName = args.length >= 2 ? args[1]
				: "lucene_server_java@localhost";
		try {
			NODE = args.length >= 3 ? new OtpNode(nodeName, args[2])
					: new OtpNode(nodeName);
			PEER = peerName;
			final OtpGenServer server = new EjisServer(NODE);
			jlog.info("Ejis Node Started at: " + nodeName
					+ "\nConnected to: " + PEER);
			forever(server);
			System.out.println("READY");
		} catch (IOException e1) {
			jlog.severe("Couldn't create node: " + e1);
			e1.printStackTrace();
			System.exit(1);
		}
	}

	protected static void forever(final OtpGenServer server) {
		new Thread("EjisServer") {
			@Override
			public void run() {
				while (true) {
					try {
						server.start();
						jlog.info("Node terminating since the server terminated normally");
						System.exit(0);
					} catch (Exception e) {
						jlog.severe("Server crashed: " + e);
						e.printStackTrace();
						jlog.info("Restarting the server");
					}
				}
			}
		}.start();
	}
}