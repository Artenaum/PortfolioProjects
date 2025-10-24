import * as yup from "yup"
import { yupResolver } from "@hookform/resolvers/yup"
import { useForm } from "react-hook-form"
import InputField from "../InputField/InputField"

const schema = yup.object({
	email: yup.string().required("Email is required").email("Email not correct"),
})

const ForgotPasswordForm1 = ({setCurrentFormState}) => {
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

	const onSubmit = () => {
		setCurrentFormState('forgot2')
	}

	return (
		<div className="form-container">
			<h1>Forgot Password</h1>
			<form className="form" onSubmit={handleSubmit(onSubmit)}>
				<p className="form-forgot-message">Enter the email address associated with your account and follow the following instructions to reset your password</p>
				<InputField
					labelValue="Email:"
					inputType="text"
					register={register}
					value="email"
					placeholder="Email"
					errorMessage={errors.email?.message}
				/>
				<input type="submit" className="submit-button" id="forgot-button" value="Next"/>
			</form>
			<div className="form-links-holder" id="form-forgot-links-holder">
				<a className="form-link-3" onClick={() => setCurrentFormState('login')}>Sign In</a>
				<a className="form-link-3" onClick={() => setCurrentFormState('register')}>Sign Up</a>
			</div>
		</div>
	)
}

export default ForgotPasswordForm1