package eu.latc.misc;

import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.HttpStatus;
import org.apache.commons.httpclient.NameValuePair;
import org.apache.commons.httpclient.URI;
import org.apache.commons.httpclient.methods.PostMethod;

public class PostReport {
	// Where the application is deployed
	static String HOST = "http://127.0.0.1:8080/LATC_Console";
	// The identifier of the configuration to send a report about
	static String ID = "02a59e182ca7ac1a012ca7ac1d190006";
	// The full URI to POST the report to
	static String API_URI = HOST + "/api/configuration/" + ID + "/reports";

	/**
	 * @param args
	 * @throws Exception
	 */
	public static void main(String[] args) throws Exception {
		// Prepare the message
		// NOTE: The date/time is automatically set to the POST date/time
		NameValuePair[] data = { 
				// Set the status message
				new NameValuePair("status", "Test report"),
				// Set the pointer to the location of the results (if any)
				new NameValuePair("location", "http://latc-project.eu"),
				// Set the size of the results (if any) or send 0
				new NameValuePair("size", "0") 
		};
		System.out.println("Message to be sent -> " + data.toString());

		// Issue the POST 
		HttpClient clientService = new HttpClient();
		PostMethod post = new PostMethod();
		post.setURI(new URI(API_URI, false));
		post.setRequestBody(data);
		int status = clientService.executeMethod(post);

		// Check response code
		if (status != HttpStatus.SC_OK) {
			throw new Exception("Received error status " + status);
		}
	}
}