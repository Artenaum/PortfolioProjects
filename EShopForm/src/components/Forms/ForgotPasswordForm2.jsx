import * as yup from "yup"
import { yupResolver } from "@hookform/resolvers/yup"
import { useForm } from "react-hook-form"
import InputField from "../InputField/InputField"

const schema = yup.object({
	newPassword: yup.string().required("Password is required").min(6, "Password not valid"),
	repeatNewPassword: yup.string().required("Repeat your password").oneOf([yup.ref("newPassword"), null], "Passwords must match!"),
})

const ForgotPasswordForm2 = ({setCurrentFormState}) => {
	const {
		register,
		handleSubmit,
		formState: {
			errors,
		}
	} = useForm({
		mode: "all",
		resolver: yupResolver(schema),
	})

	const onSubmit = (data) => {
		localStorage.setItem("password", data.newPassword)
		setCurrentFormState('login')
	}

	return (
		<div className="form-container">
			<h1>Forgot Password</h1>
			<form className="form" onSubmit={handleSubmit(onSubmit)}>
				<p className="form-forgot-message">Enter your new password</p>
				<InputField
					labelValue="New Password:"
					inputType="password"
					register={register}
					value="newPassword"
					placeholder="Password"
					errorMessage={errors.newPassword?.message}
				/>
				<InputField
					labelValue="Repeat New Password:"
					inputType="password"
					register={register}
					value="repeatNewPassword"
					placeholder="Password"
					errorMessage={errors.repeatNewPassword?.message}
				/>
				<input type="submit" className="submit-button" id="forgot-button" value="Reset Password"/>
			</form>
			<div className="form-links-holder" id="form-forgot-links-holder2">
				<a className="form-link-3" onClick={() => setCurrentFormState('login')}>Sign In</a>
				<a className="form-link-3" onClick={() => setCurrentFormState('register')}>Sign Up</a>
			</div>
		</div>
	)
}

export default ForgotPasswordForm2