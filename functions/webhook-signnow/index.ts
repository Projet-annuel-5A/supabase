// Follow this setup guide to integrate the Deno language server with your editor:
// https://deno.land/manual/getting_started/setup_your_environment
// This enables autocomplete, go to definition, etc.

// Setup type definitions for built-in Supabase Runtime APIs
/// <reference types="https://esm.sh/@supabase/functions-js/src/edge-runtime.d.ts" />

import { createClient } from 'https://esm.sh/@supabase/supabase-js'


Deno.serve(async (req) => {

	if (req.method !== "POST") {
		return new Response("Method not allowed", { status: 405 });
	}

	try {

		const supabase = createClient(
			Deno.env.get('SUPABASE_URL') ?? '',
			Deno.env.get('SUPABASE_ANON_KEY') ?? '',
			// { global: { headers: { Authorization: req.headers.get('Authorization')! } } }
		)

		const notification = await req.json();
		const documentId = notification.content.document_id;
		const userId = notification.content.user_id;

		console.log(`Document completed: ${documentId} by user: ${userId}`);

		const { data , error } = await supabase.from('interviews')
			.update({ 'agreement_ok': true })
			.filter('agreement_doc_id', 'eq', documentId);

		
		if (error) {
			console.log(error);
			throw error

		} else {
			console.log(`Agreement_ok field updated for interview with agreement_doc_id = ${documentId}`);
			console.log('Saving pdf file in storage ...');

			const bearer = '678a53fb93f401c3a511ccece2ee97b557eda4b416cb9c931e61fcf1db8a1329';
			const pdfUrl = `https://api.signnow.com/document/${documentId}/download?type=collapsed`;
			const headers = {
				"Authorization": `Bearer ${bearer}`,
				"Accept": "application/pdf"
			};

			const pdfDownloadResponse = await fetch(pdfUrl, {
				method: 'GET',
				headers: headers
			});

			if (!pdfDownloadResponse.ok) {
				throw new Error(`Network response was not ok: ${pdfDownloadResponse.statusText}`);
			}

			const blob = await pdfDownloadResponse.blob();
			const file = new File([blob], `${documentId}.pdf`, { type: 'application/pdf' });

			const { data: uploadData, error: uploadError } = await supabase.storage
				.from('agreement_files')
				.upload(`pdfs/${documentId}.pdf`, file, {
					cacheControl: '3600',
					upsert: false
			});

			if (uploadError) {
				throw new Error(`Failed to upload file to Supabase: ${uploadError.message}`);
			}
		}

		return new Response("Notification received", { status: 200 });

	} catch (error) {
		console.error("Error processing notification:", error);
		return new Response("Internal Server Error", { status: 500 });
	}
});
