type t;

type grade =
  | Good
  | Great
  | Wow;

type reviewedStatus =
  | Verified(grade)
  | NotAccepted
  | NeedsImprovement;

type status =
  | Reviewed(reviewedStatus)
  | NotReviewed;

let title: t => string;

let eventOn: t => DateTime.t;

let description: t => string;

let founderName: t => string;

let startupName: t => string;

let id: t => int;

let links: t => list(Link.t);

let files: t => list(File.t);

let image: t => option(string);

let status: t => status;

let forStartupId: (int, list(t)) => list(t);

let verificationPending: list(t) => list(t);

let verificationComplete: list(t) => list(t);

let decode: Js.Json.t => t;

let updateStatus: (status, t) => t;

let statusString: status => string;

let statusStringWithGrade: status => string;

let isVerified: t => bool;

let gradeString: grade => string;

let latestFeedback: t => option(string);

let updateFeedback: (string, t) => t;