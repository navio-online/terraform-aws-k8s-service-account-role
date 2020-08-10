resource "aws_iam_role" "this" {
  name               = "k8s-${var.k8s_namespace}-${var.k8s_serviceaccount}"
  assume_role_policy = data.aws_iam_policy_document.assume_policy.json
}

data "aws_iam_policy_document" "assume_policy" {
  override_json = var.assume_policy != "" ? var.assume_policy : null
  statement {
    sid     = "AssumeFromEksServiceAccount"
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(var.provider_url, "https://", "")}:sub"
      values   = ["system:serviceaccount:${var.k8s_namespace}:${var.k8s_serviceaccount}"]
    }

    principals {
      identifiers = [ var.provider_arn ]
      type        = "Federated"
    }
  }
}

resource "aws_iam_policy" "this" {
  count  = (var.policy_json != "none" && var.policy_arn == "none") ? 1 : 0
  policy = var.policy_json
}

resource "aws_iam_role_policy_attachment" "via_json" {
  count      = length(aws_iam_policy.this)
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this[count.index].arn
}

resource "aws_iam_role_policy_attachment" "via_arn" {
  count      = (var.policy_arn != "none" && var.policy_json == "none") ? 1 : 0
  role       = aws_iam_role.this.name
  policy_arn = var.policy_arn
}
